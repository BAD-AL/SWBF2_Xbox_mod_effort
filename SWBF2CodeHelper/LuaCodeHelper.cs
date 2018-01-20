using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SWBF2CodeHelper
{
    public class LuaCodeHelper
    {
        StringBuilder mOutput = new StringBuilder();
        /* try to decompile listiongs like:
            main <(none):0> (19 instructions, 76 bytes at 00034878)
            0 params, 5 stacks, 0 upvalues, 0 locals, 7 constants, 2 functions
	            1	[-]	GETGLOBAL	0 0	; ScriptCB_DoFile
	            2	[-]	LOADK    	1 1	; "setup_teams"
	            3	[-]	CALL     	0 2 1
	            4	[-]	GETGLOBAL	0 0	; ScriptCB_DoFile
	            5	[-]	LOADK    	1 2	; "ObjectiveConquest"
	            6	[-]	CALL     	0 2 1
	            7	[-]	LOADK    	0 3	; 2
	            8	[-]	LOADK    	1 4	; 1
	            9	[-]	LOADK    	2 4	; 1
	            10	[-]	LOADK    	3 3	; 2
	            11	[-]	CLOSURE  	4 0	; 00034A30
	            12	[-]	MOVE     	0 2 0
	            13	[-]	MOVE     	0 3 0
	            14	[-]	SETGLOBAL	4 5	; ScriptPostLoad
	            15	[-]	CLOSURE  	4 1	; 00034FB0
	            16	[-]	MOVE     	0 0 0
	            17	[-]	MOVE     	0 1 0
	            18	[-]	SETGLOBAL	4 6	; ScriptInit
	            19	[-]	RETURN   	0 1 0
         * */
        List<object> mCurrentStatement = null;
        List<string> mGlobalFunctionDeclarationList = null;
        Opcode mPrevOp = Opcode.NONE;
        List<LuaTable> mCurrentTableList = new List<LuaTable>();
        Dictionary<Opcode, string> mMathOpTable = new Dictionary<Opcode, string>{ 
        {Opcode.MUL, " * "}, {Opcode.DIV, " / "}, {Opcode.ADD, " + "}, {Opcode.SUB, " - "}
        };

        public string DecompileLuacListing(string luacListing)
        {
            mOutput.Length = 0;
            mCurrentStatement = new List<object>();
            mGlobalFunctionDeclarationList = new List<string>();
            string[] lines = luacListing.Split("\n".ToCharArray());

            ProcessLines(lines);
            return mOutput.ToString();
        }

        private void ProcessLines(string[] lines)
        {
            string line = "";
            Opcode code = Opcode.NONE;
            LuaTable currentTable = null;
            for (int i = 0; i < lines.Length; i++)
            {
                line = lines[i].Trim();
                if (line.StartsWith("--") || line.Length < 2)
                    continue;

                code = Operation.GetOpcode(line);
                currentTable = mCurrentTableList.Count > 0 ? mCurrentTableList[mCurrentTableList.Count - 1] : null;
                switch (code)
                {
                    case Opcode.LOADBOOL:
                        string boolCode = Operation.GetBoolValue(line);
                        if (currentTable != null)
                            currentTable.AddValue(boolCode);
                        else
                            mCurrentStatement.Add(boolCode);
                        break;
                    case Opcode.MUL:
                    case Opcode.ADD:
                        int mathIndex = line.IndexOf(";");
                        if ( mathIndex > -1)
                        {
                            string operation = mMathOpTable[code];
                            string[] mathArgs = line.Substring(mathIndex + 1).Trim().Split(" ".ToCharArray());
                            if (mathArgs.Length == 2)
                                mCurrentStatement.Add(mathArgs[0] + operation + mathArgs[1]);
                            else if (mathArgs.Length == 1)
                                mCurrentStatement[mCurrentStatement.Count - 1] = mathArgs[0] + operation + mCurrentStatement[mCurrentStatement.Count - 1];
                                //mCurrentStatement.Add(operation + mulArgs[0]);
                            else if (mCurrentStatement.Count == 0)
                                mCurrentStatement[mCurrentStatement.Count - 1] = operation + mCurrentStatement[mCurrentStatement.Count - 1];
                            else
                                mOutput.Append( "Don't know what I'm doing here: " + line);
                        }
                        break;
                    case Opcode.GETGLOBAL:
                        if (mCurrentTableList.Count > 0)
                        {
                            currentTable.AddValue(Operation.GetTableValue(line));
                        }
                        else
                            mCurrentStatement.Add(Operation.GetName(line));
                        break;
                    case Opcode.LOADK:
                        mCurrentStatement.Add(Operation.GetArgument(line));
                        break;
                    case Opcode.CALL:
                        if (mCurrentTableList.Count > 0)
                        {
                            //mCurrentTableList.RemoveAt(mCurrentTableList.Count - 1);
                            //mOutput.Append(mCurrentTable.ToString());
                            //mOutput.Append("\n");
                            //mCurrentTable = null;
                        }
                        else
                        {
                            AddFunctionCall(mCurrentStatement);
                            mCurrentStatement.Clear();
                        }
                        break;
                    case Opcode.SETGLOBAL:
                        if (mPrevOp == Opcode.CLOSURE)
                            mGlobalFunctionDeclarationList.Add(Operation.GetName(line));
                        else if (mPrevOp == Opcode.LOADK)
                        {
                            string name = Operation.GetName(line);
                            AddAssignment(name, mCurrentStatement);
                            mCurrentStatement.Clear();
                        }
                        else if (mCurrentTableList.Count > 0)
                        {
                            AddAssignment(Operation.GetName(line), mCurrentStatement);
                            mCurrentTableList.RemoveAt(mCurrentTableList.Count - 1);
                            mCurrentStatement.Clear();
                        }
                        else
                        {
                            AddAssignment(Operation.GetName(line), mCurrentStatement);
                            mCurrentStatement.Clear();
                            //mOutput.Append("-- OOPS Not classified: " + line);
                        }
                        break;
                    case Opcode.SELF:
                        AddToLastStatementChunk(":" + (Operation.GetName(line).Replace("\"", "")));
                        break;
                    case Opcode.NEWTABLE:
                        LuaTable t = new LuaTable();
                        mCurrentTableList.Add(t);
                        mCurrentStatement.Add(t);
                        break;
                    case Opcode.SETTABLE:
                        if (mCurrentTableList.Count > 0)
                        {
                            string key = Operation.GetTableKey(line);
                            string val = Operation.GetTableValue(line);
                            if (key != null && val != null)
                                currentTable.AddEntry(key, val);
                            else if (key != null)
                                currentTable.AddKey(key);
                            else if (val != null)
                                currentTable.AddValue(val);
                            else
                                mOutput.Append("SETTABLE Should not get here " + line);
                        }
                        break;
                    case Opcode.FUNCTION_DEF:

                        break;
                    case Opcode.PARAMS:
                        if (mPrevOp != Opcode.MAIN_DEF)
                        {
                            string num = Operation.GetNextToken(0, line);
                            int numParams = Int32.Parse(num);
                            DeclareFunction(numParams);
                        }
                        break;
                    case Opcode.CLOSURE:
                        break;
                    case Opcode.RETURN:
                        mOutput.Append("return\nend\n");
                        break;
                }
                mPrevOp = code;
            }
        }

        private void DeclareFunction(int numParams)
        {
            string functionName = mGlobalFunctionDeclarationList[0];
            mGlobalFunctionDeclarationList.RemoveAt(0);
            mOutput.Append("function " + functionName + "(");
            for (int i = 1; i < numParams + 1; i++)
            {
                mOutput.Append("param" + i);
                mOutput.Append(",");
            }
            if (numParams > 0) mOutput.Remove(mOutput.Length - 1, 1); // remove last comma
            mOutput.Append(")\n");
        }

        private void AddToLastStatementChunk(string s)
        {
            mCurrentStatement[mCurrentStatement.Count - 1] = mCurrentStatement[mCurrentStatement.Count - 1] + s;
        }

        private void AddFunctionCall(List<object> functionStatement)
        {
            mOutput.Append(functionStatement[0]);
            mOutput.Append("(");
            for (int i = 1; i < functionStatement.Count; i++)
            {
                mOutput.Append(functionStatement[i].ToString());
                mOutput.Append(",");
            }
            if (functionStatement.Count > 1)
                mOutput.Remove(mOutput.Length - 1, 1); // remove last comma

            mOutput.Append(")\n");
        }

        private void AddAssignment(string name, List<object> assignmentList)
        {
            if (assignmentList.Count > 0)
            {
                mOutput.Append(name);
                mOutput.Append(" = ");
                if (assignmentList.Count == 1)
                    mOutput.Append(assignmentList[0]);
                else if (mCurrentTableList.Count > 0)
                {
                    foreach (object o in assignmentList)
                        mOutput.Append(o.ToString());
                }
            }
            else
            {
                mOutput.Append("this assignment goes to the previous statement:" + name);
            }
            mOutput.Append("\n");
        }
    }
}
