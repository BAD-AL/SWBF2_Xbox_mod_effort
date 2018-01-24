using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SWBF2CodeHelper
{
    public class LuaCodeHelper2
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

        private void ProcessLines(string[] lines, LuaChunk chunk)
        {
            string line = "";
            Opcode code = Opcode.NONE;
            Opcode peek = Opcode.NONE;
            Opcode prevOp = Opcode.NONE;

            LuaTable currentTable = null;
            LuaChunk newOne = null;
            LuaChunk parentChunk = chunk;
            LuaChunk currentChunk = new LuaChunk();
            parentChunk.AddChunk(currentChunk);
            for (int i = 0; i < lines.Length; i++)
            {
                line = lines[i].Trim();
                if (line.StartsWith("--") || line.Length < 2)
                    continue;

                code = Operation.GetOpcode(line);
                peek = i + 1 < lines.Length ? Operation.GetOpcode(lines[i + 1]) : Opcode.NONE;
                switch (code)
                {
                    case Opcode.LOADBOOL:
                        break;
                    case Opcode.GETGLOBAL:
                        if (prevOp == Opcode.NEWTABLE)
                        {
                            currentTable.AddValue(new LuaChunk() { ConstantValue = Operation.GetName(line) });
                        }
                        else if (currentChunk.GlobalName == null)
                            currentChunk.GlobalName = Operation.GetName(line);
                        else
                        {
                            newOne = new LuaChunk();
                            newOne.GlobalName = Operation.GetName(line);
                            currentChunk.ParentChunk.AddChunk(newOne);
                            currentChunk = newOne;
                        }
                        break;
                    case Opcode.LOADK:
                        currentChunk.AddConstant(new LuaChunk() { ConstantValue = Operation.GetArgument(line) });
                        break;
                    case Opcode.CALL:
                        currentChunk.SetCall();
                        newOne = new LuaChunk();
                        currentChunk.ParentChunk.AddChunk(newOne);
                        currentChunk = newOne;
                        break;
                    case Opcode.SETGLOBAL:
                        if (prevOp == Opcode.CALL)
                        {
                            LuaChunk bro = currentChunk.GetOlderSipling();
                            if (bro != null)
                                bro.AddAssignmentLvalue(Operation.GetName(line));
                            else
                                throw new Exception("No older sibling to assign to!!! Logic needs to change!!!");
                        }
                        else if (prevOp == Opcode.LOADK || prevOp == Opcode.SETTABLE || prevOp == Opcode.LOADBOOL)
                        {
                            currentChunk.AddAssignmentLvalue(Operation.GetName(line));
                            newOne = new LuaChunk();
                            currentChunk.ParentChunk.AddChunk(newOne);
                            currentChunk = newOne;
                        }
                        
                        break;
                    case Opcode.LT:  case Opcode.LE: case Opcode.EQ:
                        currentChunk = currentChunk.ParentChunk.ApplyExpression(code);
                        if (peek == Opcode.JMP)
                        {
                            IfStatement stmt = new IfStatement();
                            stmt.Expression = currentChunk;
                            stmt.ThenChunk = GatherThenChunk(lines, i+2);
                            stmt.ElseChunk = GatherElseChunk(lines, i + 1);
                            currentChunk.ParentChunk.ReplaceChunk(currentChunk, stmt);
                            //currentChunk = stmt;
                            newOne = new LuaChunk();
                            currentChunk.ParentChunk.AddChunk(newOne);
                            currentChunk = newOne;
                            i = stmt.ElseChunk.LastLine + 1;
                        }
                        break;
                    case Opcode.ADD: case Opcode.SUB:
                    case Opcode.MUL: case Opcode.DIV:
                    case Opcode.POW:
                        List<string> mathArgs = Operation.GetArguments(line);
                        if (mathArgs.Count == 2)
                        {
                            LuaExpression expr = new LuaExpression()
                            {
                                RValue = new LuaChunk() { ConstantValue = mathArgs[1] },
                                LValue = new LuaChunk() { ConstantValue = mathArgs[0] },
                                Operation = code
                            };
                            if (currentChunk.GlobalName != null) currentChunk.AddChunk(expr);
                        }
                        else if (mathArgs.Count == 1)
                        {
                            LuaExpression le = new LuaExpression()
                            {
                                LValue = new LuaChunk() { ConstantValue = mathArgs[0] },
                                Operation = code
                            };

                            //throw new Exception("Fix the code!!!");
                        }
                        else
                            throw new Exception("Fix the MATH operations with no args!!!");// previous 2 globals or locals?
                        break;
                    case Opcode.JMP:  // line example  : 14	[-]	JMP      	0 4	; to 19
                        if (" LE LT EQ ".IndexOf(prevOp.ToString()) > -1)
                        {

                        }
                        break;
                    case Opcode.SELF:
                        break;
                    case Opcode.SETLIST:
                        if (currentTable != null)
                            currentTable.SetList();
                        else
                            throw new Exception("FIX THE TABLE PARSING CODE!! SETLIST with no current table???");
                        break;
                    case Opcode.NEWTABLE:
                        currentTable = new LuaTable(true);
                        if (currentChunk.LuaType == LuaType.TABLE)
                            ((LuaTable)currentChunk).AddValue(currentTable);
                        else
                            currentChunk.AddChunk(currentTable);// I think this works, not sure though...
                        currentChunk = currentTable;
                        break;
                    case Opcode.SETTABLE:  // When to transition 'currentChunk' to its parent?
                        List<string> args = Operation.GetArguments(line);
                        if (args.Count == 2)
                            currentTable.AddEntry(args[0], new LuaChunk() { ConstantValue = args[1] });
                        else if (args.Count == 1 && currentTable.ParentChunk.LuaType == LuaType.TABLE)
                        {
                            //currentChunk = currentTable = (LuaTable)currentTable.ParentChunk;
                            currentTable.AddKey(args[0]);
                        }
                        else if (args.Count == 1)
                        {
                        }
                        else
                            throw new Exception("Fix the Table Parsing Code!!!");
                        break;
                    case Opcode.FUNCTION_DEF:
                        LuaChunk func = GatherFunctionChunk(lines, i);
                        i = func.LastLine + 1;
                        currentChunk.ParentChunk.AddChunk(func);
                        currentChunk = func;
                        break;
                    case Opcode.PARAMS:
                        break;
                    case Opcode.CLOSURE:
                        string closureNumber = Operation.GetClosureNumber(line);
                        string functionName = Operation.GetName(lines[i+1]);
                        sClosureMapping.Add(closureNumber, functionName);
                        break;
                    case Opcode.RETURN:
                        break;
                }
                prevOp = code;
            }
        }

        private LuaChunk GatherFunctionChunk(string[] lines, int index)
        {
            List<string> dudes = new List<string>();
            int i = index+1;
            // process to next JMP
            while (i < lines.Length &&  lines[i].Length > 3)
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
            functionChunk.LastLine = i;
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
            int endLinesIndex = JumpToLineNumber( lines[startLinesIndex - 1]) + difference;
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
            int index = line.IndexOf(" to ")+ 4;
            if (index > -1 && line.IndexOf("JMP") > -1)
                retVal = Int32.Parse(line.Substring(index).Trim());
            return retVal;
        }
    }
}
