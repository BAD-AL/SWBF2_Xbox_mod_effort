using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SWBF2CodeHelper
{
    public class LuaCodeHelper3
    {
        private static Dictionary<string, string> sClosureMapping = new Dictionary<string, string>();

        public string DecompileLuacListing(string luacListing)
        {
            string[] lines = luacListing.Replace("\r\n", "\n").Split("\n".ToCharArray());

            sClosureMapping.Clear();
            LuaChunk mainChunk = new LuaChunk();
            ProcessLines(lines, mainChunk);
            return mainChunk.ToString();
        }

        private LuaChunk[] mRegisters       = new LuaChunk[250];
        private LuaChunk[] mLocalVarBackup  = new LuaChunk[250]; // the listing info does not give us enough to determine all the 
                                                                 // info about 'locals' that we need so we create a backup for local variables. 

        private void ProcessLines(string[] lines, LuaChunk chunk)
        {
            string line = "";
            Opcode code = Opcode.NONE;
            Opcode peek = Opcode.NONE;
            Opcode prevOp = Opcode.NONE;
            int j = 0; // looping var;

            int currentRegister = -1;
            LuaChunk tmp = null;
            LuaChunk currentRegisterValue = null;
            LuaTable currentTable = null;
            LuaTable tmpTable = null;
            LuaChunk newOne = null;
            LuaChunk scopeChunk = chunk;
            LuaExpression tmpExpr = null;
            List<int> vmArgs = null;

            for (int i = 0; i < lines.Length; i++)
            {
                line = lines[i].Trim();
                if (line.StartsWith("--") || line.Length < 2)
                    continue;

                code = Operation.GetOpcode(line);
                currentRegister = Operation.GetRegister(line);
                vmArgs = Operation.GetVMArgs(line);
                currentRegisterValue = currentRegister > -1 ? mRegisters[currentRegister] : null;
                peek = i + 1 < lines.Length ? Operation.GetOpcode(lines[i + 1]) : Opcode.NONE;
                //try {
                    switch (code)
                    {
                        case Opcode.LOADBOOL:
                            // LOADBOOL A B C               R(A) := (Bool)B; if (C) PC++
                            // Loads a boolean value (true or false) into register R(A). 
                            // true is usually encoded as an integer 1, false is always 0. If C is non-zero, 
                            // then the next instruction is skipped (this is used when you have an assignment 
                            // statement where the expression uses relational operators, e.g. M = K>5.)
                            string bVal = (vmArgs[1] > 0).ToString().ToLower();
                            newOne = new LuaChunk() { ConstantValue = bVal };
                            mRegisters[currentRegister] = newOne;
                            // 'C' part should be handled by compare & jump handling.
                            break;
                        case Opcode.GETGLOBAL:
                            newOne = new LuaChunk();
                            newOne.GlobalName = Operation.GetName(line);
                            mRegisters[currentRegister] = newOne;
                            break;
                        case Opcode.MOVE:   // MOVE A  B R(A) := R(B)
                            // Copies the value of register R(B) into register R(A). 
                            // If R(B) holds a table, function or userdata, then the reference to that object 
                            // is copied. MOVE is often used for moving values into place for the next operation.
                            if (mRegisters[vmArgs[0]] != null && mRegisters[vmArgs[0]].LuaType == LuaType.CONSTANT)
                                mRegisters[currentRegister] = mRegisters[vmArgs[0]].Clone();
                            else
                                mRegisters[currentRegister] = mRegisters[vmArgs[0]];
                            if (mRegisters[currentRegister] == null)
                                mRegisters[currentRegister] = GetLocalBackup(vmArgs[0]);
                            break;
                        case Opcode.LOADK:
                            tmp = new LuaChunk() { ConstantValue = Operation.GetArgument(line) };
                            mRegisters[currentRegister] = tmp;
                            break;
                        case Opcode.LOADNIL:  // LOADNIL A B R(A) := ... := R(B) := nil
                            // Sets a range of registers from R(A) to R(B) to nil. 
                            // If a single register is to be assigned to, then R(A) = R(B). 
                            // When two or more consecutive locals need to be assigned nil values, 
                            // only a single LOADNIL is needed
                            tmp = new LuaChunk() { ConstantValue = "nil" };
                            for (j = currentRegister; j < vmArgs[0]; j++)
                                mRegisters[j] = tmp;
                            break;
                        case Opcode.CALL:
                            // CALL A B C                R(A), ... ,R(A+C-2) := R(A)(R(A+1), ... ,R(A+B-1))
                            // Performs a function call, with register R(A) holding the reference to the 
                            // function object to be called. Parameters to the function are placed in the 
                            // registers following R(A). If B is 1, the function has no parameters. 
                            // If B is 2 or more, there are (B-1) parameters.  If C is 1, no return results are saved. 
                            // If C is 2 or more, (C-1) return values are saved. If C is 0, then multiple return results are saved, 
                            // depending on the called function.

                            int numArgs = vmArgs[0] - 1;
                            int reg = currentRegister;
                            if (currentRegisterValue.Self != null) // For object-oriented programming using tables. Retrieves a function
                            {                                      // reference from a table element and places it in register R(A), then a
                                reg++;                             // reference to the table itself is placed in the next register, R(A+1).
                                numArgs--;
                            }
                            for (j = 0; j < numArgs; j++)
                            {
                                currentRegisterValue.AddChunk(PluckRegister(reg + 1 + j));
                            }
                            // when 'B' argument == 0, that means multiple parameters; the function takes C-1 parameters
                            if (vmArgs[0] == 0)
                            {
                                j = currentRegister + 1;
                                while (mRegisters[j] != null) //need to check register before calling 'PluckRegister' because of locals backup.
                                {
                                    currentRegisterValue.AddChunk(PluckRegister(j));
                                    j++;
                                }
                            }
                            currentRegisterValue.SetCall();
                            if (currentRegisterValue.ParentChunk == null)
                                scopeChunk.AddChunk(currentRegisterValue);

                            break;
                        case Opcode.SETGLOBAL:
                            currentRegisterValue.AddAssignmentLvalue(Operation.GetName(line));
                            if (currentRegisterValue.ParentChunk == null)
                                scopeChunk.AddChunk(currentRegisterValue);
                            break;
                        case Opcode.TEST:
                            // TEST A B C                if (R(B) <=> C) then R(A) := R(B) else PC++
                            // Used to implement and and or logical operators, or for testing a single
                            // register in a conditional statement.
                            // For TEST, register R(B) is coerced into a boolean and compared to
                            // the boolean field C. If R(B) matches C, the next instruction is skipped,
                            // otherwise R(B) is assigned to R(A) and the VM continues with the next
                            // instruction. The and operator uses a C of 0 (false) while or uses a C value
                            // of 1 (true).

                            break;
                        case Opcode.LT: // Compares RK(B) and RK(C), which may be registers or constants. If the
                        case Opcode.LE: // boolean result is not A, then skip the next instruction. Conversely, if the
                        case Opcode.EQ: // boolean result equals A, continue with the next instruction.
                            IfStatement if_stmt = new IfStatement();

                            if_stmt.Expression = new LuaExpression()
                            {
                                Operation = code,
                                LValue = GetExpressionArgument(line, 1),
                                RValue = GetExpressionArgument(line, 2)
                            };
                            if_stmt.ThenChunk = GatherThenChunk(lines, i + 2);
                            if_stmt.ElseChunk = GatherElseChunk(lines, i + 1);
                            scopeChunk.AddChunk(if_stmt);
                            i = if_stmt.ElseChunk.LastLine + 1; // is this always correct?
                            break;
                        case Opcode.ADD: // Binary operators (arithmetic operators with two inputs.) 
                        case Opcode.SUB: // The result of the operation between RK(B) and RK(C) is placed into R(A). 
                        case Opcode.MUL: // These instructions are in the classic 3-register style. RK(B) and RK(C) 
                        case Opcode.DIV: // may be either registers or constants in the constant pool.
                        case Opcode.POW: // R(A) := RK(B) + RK(C)
                            List<string> mathArgs = Operation.GetArguments(line);
                            if (mathArgs.Count == 2)
                            {
                                tmpExpr = new LuaExpression()
                                {
                                    Operation = code,
                                    LValue = GetExpressionArgument(line, 1),
                                    RValue = GetExpressionArgument(line, 2)
                                };
                                mRegisters[currentRegister] = tmpExpr;
                            }
                            else if (mathArgs.Count == 1)
                            {
                                LuaExpression newExpr = new LuaExpression() { Operation = code };
                                newExpr.LValue = new LuaChunk() { ConstantValue = mathArgs[0] };
                                newExpr.RValue = mRegisters[vmArgs[1]];
                                mRegisters[currentRegister] = newExpr;
                            }
                            else // operate on registers
                            {
                                tmpExpr = new LuaExpression() { Operation = code };
                                tmpExpr.LValue = mRegisters[vmArgs[0]];
                                tmpExpr.RValue = mRegisters[vmArgs[1]];
                                mRegisters[currentRegister] = tmpExpr;
                            }
                            break;
                        case Opcode.JMP:  // line example  : 14	[-]	JMP      	0 4	; to 19
                            if (" LE LT EQ ".IndexOf(prevOp.ToString()) > -1)
                            {

                            }
                            break;
                        case Opcode.SELF: // For object-oriented programming using tables. Retrieves a function reference from a 
                            // table element and places it in register R(A), then a reference to the table itself 
                            // is placed in the next register, R(A+1). This instruction saves some messy manipulation 
                            // when setting up a method call
                            currentRegisterValue.Self = Operation.GetArgument(line).Replace("\"", "");
                            break;
                        case Opcode.GETTABLE:
                            currentRegisterValue.GetTable = Operation.GetArgument(line).Replace("\"", "");
                            break;
                        case Opcode.SETLIST: // 46	[-]	SETLIST  	0 7 ==> table in '0' gets the next 7 register values
                            currentTable = currentRegisterValue as LuaTable;
                            for (j = currentRegister + 1; j <= currentRegister + 1 + vmArgs[0]; j++) // this math correct???
                            {
                                currentTable.AddValue(PluckRegister(j));
                            }
                            break;
                        case Opcode.NEWTABLE:
                            //  6	[-]	NEWTABLE 	0 3 0   ;-- Creates a table (register 0) that will be used as a list to hold 3 items.
                            //  7	[-]	NEWTABLE 	1 0 3   ;-- Creates a table (register 1) that will be used to hold 3 table entries.
                            currentTable = new LuaTable(vmArgs[0] > 0); // 'vmArgs[0] > 0' will be true for lists
                            mRegisters[currentRegister] = currentTable;
                            break;
                        case Opcode.SETTABLE:
                            // SETTABLE A B C                        R(A)[RK(B)] := RK(C)
                            // Copies the value from register R(C) or a constant into a table element. The
                            // table is referenced by register R(A), while the index to the table is given by
                            // RK(B), which may be the value of register R(B) or a constant.
                            //
                            // 	12	[-]	SETTABLE 	2 136 3	; "soldier"  ==> "soldier" is the key, content of register '3' is the value
                            List<string> args = Operation.GetArguments(line);
                            tmpTable = currentRegisterValue as LuaTable;
                            if (currentRegisterValue != null && tmpTable == null)
                            {
                                tmpTable = new LuaTable(false)
                                {
                                    GetTable = currentRegisterValue.GetTable,
                                    GlobalName = currentRegisterValue.GlobalName,
                                    Self = currentRegisterValue.Self
                                };
                                if (currentRegisterValue.ParentChunk != null)
                                    currentRegisterValue.ParentChunk.ReplaceChunk(currentRegisterValue, tmpTable);
                                mRegisters[currentRegister] = tmpTable;
                            }
                            if (args.Count == 2)
                                tmpTable.AddEntry(args[0], new LuaChunk() { ConstantValue = args[1] });
                            else if (args.Count == 1)
                            {
                                tmpTable.AddEntry(args[0], PluckRegister(vmArgs[1]));
                            }
                            break;
                        case Opcode.FUNCTION_DEF:
                            LuaChunk func = GatherFunctionChunk(lines, i);
                            i = func.LastLine;
                            scopeChunk.AddChunk(func);
                            break;
                        case Opcode.MAIN_DEF:
                        case Opcode.PARAMS:
                            break;
                        case Opcode.CLOSURE:
                            string closureNumber = Operation.GetClosureNumber(line);
                            string functionName = Operation.GetName(lines[i + 1]);
                            sClosureMapping.Add(closureNumber, functionName);
                            i++;
                            break;
                        case Opcode.FORLOOP:

                            break;
                        case Opcode.RETURN:
                            break;
                        default:
                            Console.WriteLine(code + " NOT IMPLEMENTED ");
                            break;
                    }
                    prevOp = code;
                
                //}catch (Exception ex)
                //{
                //    LuaChunk problemChild = new LuaChunk() { ConstantValue = line };
                //    scopeChunk.AddChunk(problemChild);
                //}
            }
        }

        private LuaChunk GetLocalBackup(int reg )
        {
            LuaChunk retVal = null;
            LuaChunk chunk =  mLocalVarBackup[reg];
            if (chunk != null)
            {
                retVal = new LuaChunk()
                {
                    ConstantValue = chunk.ConstantValue,
                    GetTable = chunk.GetTable,
                    Self = chunk.Self,
                    GlobalName = chunk.GlobalName
                };
                //retVal = chunk.Clone();
            }
            return retVal;
        }

        /// <summary>
        /// Get an argument for an expression
        /// </summary>
        /// <param name="line">the source line</param>
        /// <param name="argNumber"> the first or second argument (1 or 2 is valid)</param>
        /// <returns></returns>
        private LuaChunk GetExpressionArgument(string line, int argNumber)
        {
            // this is complex, I hope it's correct...
            if (argNumber > 2) argNumber = 2; 
            else if (argNumber < 1) argNumber = 1;

            List<int> vmArgs = Operation.GetVMArgs(line);
            List<string> args = Operation.GetArguments(line);
            if (args[0] == "-") args.RemoveAt(0);
            if (args.Count == 2)
                return new LuaChunk() { ConstantValue = args[argNumber - 1] };
            else if( args.Count == 1 && argNumber == 1)
            {
                if (vmArgs[0] < mRegisters.Length && (mRegisters[vmArgs[0]] != null || mLocalVarBackup[vmArgs[0]] != null ))
                    return PluckRegister(vmArgs[0]);
                if (args.Count > 0) // it's not in a register, must be the constant.
                    return new LuaChunk() { ConstantValue = args[0] };
            }
            else if (args.Count == 1 && argNumber == 2)
            {
                if (vmArgs[1] < mRegisters.Length && (mRegisters[vmArgs[1]] != null || mLocalVarBackup[vmArgs[1]] != null))
                    return PluckRegister(vmArgs[1]);
                if (args.Count > 0) // it's not in a register, must be the constant.
                    return new LuaChunk() { ConstantValue = args[0] };
            }
             // it's in a register
            return PluckRegister(vmArgs[argNumber - 1]);
        }

        /// <summary>
        /// This gets tricky because the listing doesn't have the all the info that is needed to deal with local variables.
        /// We keep a backup of the values in mLocalVarBackup to account for this.
        /// When the functionality is needed where we process arguments on the stack, we'll need to check if it is null before we 
        /// call this function.
        /// </summary>
        /// <param name="registerNumber"></param>
        /// <returns></returns>
        private LuaChunk PluckRegister(int registerNumber)
        {
            LuaChunk retVal = mRegisters[registerNumber];

            if(retVal != null )
                mLocalVarBackup[registerNumber] = retVal;
            
            mRegisters[registerNumber] = null;

            if (retVal == null)
                retVal = GetLocalBackup(registerNumber);
            
            return retVal;
        }


        private LuaChunk GatherFunctionChunk(string[] lines, int index)
        {
            List<string> dudes = new List<string>();
            int i = index + 1;
            // process to next JMP
            while (i < lines.Length && lines[i].Length > 3)
            {
                dudes.Add(lines[i]);
                i++;
            }
            LuaFunction functionChunk = new LuaFunction();
            functionChunk.Name = GetFunctionName(lines[index]); // should be info like: "function <(none):24> (598 instructions, 2392 bytes at 00245A90)"
            string num = Operation.GetNextToken(0, lines[index + 1]); // Should be line like like: "0 params, 2 stacks, 0 upvalues, 0 locals, 1 constant, 0 functions"
            functionChunk.NumberOfPraams = Int32.Parse(num);

            functionChunk.Body = new LuaChunk();
            ProcessLines(dudes.ToArray(), functionChunk.Body);
            functionChunk.LastLine = i - 1;
            return functionChunk;
        }

        private string GetFunctionName(string line)
        {
            if (line.IndexOf("function") > -1)
            {
                int funcIdIndex = line.IndexOf("at ") + 3;
                if (funcIdIndex > 20)
                {
                    string functionId = line.Substring(funcIdIndex).Replace(")", "").Trim();
                    if (sClosureMapping.ContainsKey(functionId))
                        return sClosureMapping[functionId];
                }
            }
            return null;
        }

        private LuaChunk GatherThenChunk(string[] lines, int index)
        {
            List<string> dudes = new List<string>();
            int i = index;
            // process to next JMP
            while (lines[i].IndexOf("[-]	JMP") == -1)
            {
                dudes.Add(lines[i]);
                i++;
            }
            LuaChunk thenChunk = new LuaChunk();
            ProcessLines(dudes.ToArray(), thenChunk);
            thenChunk.LastLine = i;
            return thenChunk;
        }

        private LuaChunk GatherElseChunk(string[] lines, int index)
        {
            int currentLineNumber = GetLineNumber(lines[index]);
            int startLineNumber = JumpToLineNumber(lines[index]);
            int difference = index - currentLineNumber;

            int startLinesIndex = startLineNumber + difference;
            // figure out where to end
            int endLinesIndex = JumpToLineNumber(lines[startLinesIndex - 1]) + difference;
            List<string> dudes = new List<string>();
            for (int i = startLinesIndex; i < endLinesIndex; i++)
                dudes.Add(lines[i]);

            LuaChunk elseChunk = new LuaChunk();
            ProcessLines(dudes.ToArray(), elseChunk);
            elseChunk.LastLine = endLinesIndex;
            return elseChunk;
        }


        private int GetLineNumber(string line)
        {
            string num = Operation.GetNextToken(0, line);
            return Int32.Parse(num);
        }

        private int JumpToLineNumber(string line)
        {
            int retVal = -1;
            int index = line.IndexOf(" to ") + 4;
            if (index > -1 && line.IndexOf("JMP") > -1)
                retVal = Int32.Parse(line.Substring(index).Trim());
            return retVal;
        }
    }

}
