using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SWBF2CodeHelper
{
    public static class Operation
    {
        public static Opcode GetOpcode(string line)
        {
            Opcode retVal = Opcode.NONE;
            if (line.Length > 8 && !line.StartsWith("--"))
            {
                string token = "";
                string getAt = "[-]";
                int dashIndex = line.IndexOf(getAt);
                if (dashIndex > -1)
                {
                    token = GetNextToken(dashIndex + getAt.Length, line);
                    retVal = (Opcode)Enum.Parse(typeof(Opcode), token);
                }
                else if (line.StartsWith("main"))
                    retVal = Opcode.MAIN_DEF;
                else if (line.StartsWith("function"))
                    retVal = Opcode.FUNCTION_DEF;
                else if (line.IndexOf("params,") >= 2)
                    retVal = Opcode.PARAMS;
            }
            return retVal;
        }

        public static string GetName(string line)
        {
            string retVal = null;
            int index = line.IndexOf(";");
            
            if (index > -1)
                retVal = GetNextToken(index+1, line);

            return retVal;
        }

        public static string GetTableKey(string line)
        {
            string key = GetName(line);
            int index = line.IndexOf(key) + key.Length;
            string val = GetNextToken(index, line);
            if (val == null && line.IndexOf("GETGLOBAL") > 4)
            {
                key = null;
            }
            return key;
        }

        public static string GetTableValue(string line)
        {
            string key = GetName(line);
            int index = line.IndexOf(key) + key.Length;
            string val = GetNextToken(index, line);
            if (val == null && line.IndexOf("GETGLOBAL") > 4)
                val = key;
            return val;
        }

        public static string GetArgument(string line)
        {
            string retVal = null;
            int index = line.IndexOf("; ");
            if (index > -1)
                retVal = line.Substring(index + 2);
            return retVal;
        }

        public static List<string> GetArguments(string line)
        {
            string arg = null;
            List<string> retVal = new List<string>();
            int index = line.IndexOf("; ") +2;
            while (index > 3)
            {
                arg = GetNextToken(index, line, out index);
                if (arg != null) retVal.Add(arg);
            }
            return retVal;
        }


        public static int GetRegister(string line)
        {
            int index = line.IndexOf("[-]") + 3;
            //register is 4th token, 2 tokens after the '[-]' token

            GetNextToken(index, line, out index);
            string num = GetNextToken(index, line, out index);
            int retVal = -1;
            if( num != null)
                Int32.TryParse(num, out retVal);
            return retVal;
        }

        /// <summary>
        /// In the VM code listing we get some lines like:
        ///     13    [-]    LT           0 1 0
        ///     14    [-]    JMP          0 4    ; to 19
        ///     the numbers after the Operation are the arguments to the vm. 
        ///     They mean different things to different operations. For details see:
        ///     http://luaforge.net/docman/83/98/ANoFrillsIntroToLua51VMInstructions.pdf
        /// </summary>
        /// <param name="line"></param>
        /// <returns>Returns the list of VM args excluding register. Should be 1 or 2 values.</returns>
        public static List<int> GetVMArgs(string line)
        {
            int index = line.IndexOf("[-]") + 3;
            int index2 = line.IndexOf(";");
            if (index2 > -1)
                line = line.Substring(0, index2 - 1);
            if (index < 3)
                return null;
            
            //register is 4th token, 2 tokens after the '[-]' token
            GetNextToken(index, line, out index);// go past operation
            GetNextToken(index, line, out index);// go past register
            string num = "";
            List<int> retVal = new List<int>();
            while (num != null)
            {
                num = GetNextToken(index, line, out index);
                int tmp = -1;
                if (num != null)
                {
                    Int32.TryParse(num, out tmp);
                    retVal.Add(tmp);
                }
            }
            return retVal;
        }

        public static string GetNextToken(int position, string line)
        {
            int dude = 0;
            return GetNextToken(position, line, out dude);
        }

        /// <summary>
        /// gets the next token on the line.
        /// </summary>
        /// <param name="position">the starting position </param>
        /// <param name="line">the line to get tokens from</param>
        /// <param name="stopIndex">-1 if no more line to process.</param>
        /// <returns>the next token.</returns>
        public static string GetNextToken(int position, string line, out int lastPosition)
        {
            string retVal = null;
            lastPosition = -1;
            if (position < line.Length)
            {
                int start = position;
                while (Char.IsWhiteSpace(line[start])) start++;
                int end = start + 1;
                while (end < line.Length && !Char.IsWhiteSpace(line[end])) end++;
                retVal = line.Substring(start, end - start);
                lastPosition = end;
            }
            return retVal;
        }

        public static string GetBoolValue(string line)
        {
            string retVal = "true";
            int index = line.IndexOf("LOADBOOL");
            if (index > -1)
            {
                string[] parts = (line.Substring(index+ "LOADBOOL".Length+1).Trim()).Split(" ".ToCharArray());
                if (parts[1] == "0")
                    retVal = "false";
            }
            return retVal;
        }

        public static string GetClosureNumber(string line)
        {
            int index = line.IndexOf("CLOSURE");
            if (index > 5 && index < 10)
            {
                return GetArgument(line).Trim();
            }
            return null;
        }
    }

    public enum Opcode
    {
        NONE,
        FUNCTION_DEF,
        MAIN_DEF,
        IGNORE,
        PARAMS,

        MOVE,            // Copy a value between registers  
        LOADK,           // Load a constant into a register  
        LOADBOOL,        // Load a boolean into a register  
        LOADNIL,         // Load nil values into a range of registers  
        GETUPVAL,        // Read an upvalue into a register  
        GETGLOBAL,       // Read a global variable into a register  
        GETTABLE,        // Read a table element into a register  
        SETGLOBAL,       // Write a register value into a global variable  
        SETUPVAL,        // Write a register value into an upvalue  
        SETTABLE,        // Write a register value into a table element 
        NEWTABLE,        // Create a new table 11 SELF Prepare an object method for calling 
        SELF,            // Prepare an object method for calling 
        ADD,             // Addition 
        SUB,             // Subtraction 
        MUL,             // Multiplication 
        DIV,             // Division 
        POW,             // Exponentiation 
        UNM,             // Unary minus 
        NOT,             // Logical NOT 
        CONCAT,          // Concatenate a range of registers 
        JMP,             // Unconditional jump 
        EQ,              // Equality test 
        LT,              // Less than test 
        LE,              // Less than or equal to test 
        TEST,            // Test for short-circuit logical and and or evaluation 
        CALL,            // Call a closure 
        TAILCALL,        // Perform a tail call 
        RETURN,          // Return from function call 
        FORLOOP,         // Iterate a numeric for loop 
        TFORLOOP,        // Iterate a generic for loop 
        TFORPREP,        // Initialization for a generic for loop 
        SETLIST,         // Set a range of array elements for a table 
        SETLISTO,        // Set a variable number of table elements 
        CLOSE,           // Close a range of locals being used as upvalues 
        CLOSURE,         // Create a closure of a function prototype
    }

    public enum LuaType
    {
        NONE,
        BLOCK_STATEMENT,
        IF_STATEMENT,
        FUNCTION_CALL,
        FUNCTION_DEF,
        TABLE,
        CONSTANT,
        EXPRESSION,
        SIMPLE_ASSIGNMENT
    }
    
}
