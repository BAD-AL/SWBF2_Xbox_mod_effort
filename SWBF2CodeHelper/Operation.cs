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

        public static string GetNextToken(int position, string line)
        {
            string retVal = null;
            if (position < line.Length)
            {
                int start = position;
                while (Char.IsWhiteSpace(line[start])) start++;
                int end = start + 1;
                while (end < line.Length && !Char.IsWhiteSpace(line[end])) end++;
                retVal = line.Substring(start, end - start);
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
    }

    public enum Opcode
    {
        NONE,
        FUNCTION_DEF,
        MAIN_DEF,
        IGNORE,
        PARAMS,

        MOVE,       // Copy a value between registers 
        LOADK,      // Load a constant into a register 
        LOADBOOL,   // Load a boolean into a register 
        LOADNIL,    // Load nil values into a range of registers 
        GETUPVAL,   // Read an upvalue into a register 
        GETGLOBAL,  // Read a global variable into a register 
        GETTABLE,   // Read a table element into a register 
        SETGLOBAL,  // Write a register value into a global variable 
        SETUPVAL,   // Write a register value into an upvalue 
        SETTABLE,   // Write a register value into a table element
        NEWTABLE,   // Create a new table
        SELF,       // Prepare an object method for calling
        ADD,        // Addition operator
        SUB,        // Subtraction operator
        MUL,        // Multiplication operator
        DIV,        // Division operator
        MOD,        // Modulus (remainder) operator
        POW,        // Exponentiation operator
        UNM,        // Unary minus operator
        NOT,        // Logical NOT operator
        LEN,        // Length operator
        CONCAT,     // Concatenate a range of registers
        JMP,        // Unconditional jump
        EQ,         // Equality test
        LT,         // Less than test
        LE,         // Less than or equal to test
        TEST,       // Boolean test, with conditional jump
        TESTSET,    // Boolean test, with conditional jump and assignment
        CALL,       // Call a closure
        TAILCALL,   // Perform a tail call
        RETURN,     // Return from function call
        FORLOOP,    // Iterate a numeric for loop
        FORPREP,    // Initialization for a numeric for loop
        TFORLOOP,   // Iterate a generic for loop
        SETLIST,    // Set a range of array elements for a table
        CLOSE,      // Close a range of locals being used as upvalues
        CLOSURE,    // Create a closure of a function prototype
        VARARG,     // Assign vararg function arguments to registers
    }

    public class LuaTable
    {
        StringBuilder mEntries = new StringBuilder();

        string mKeyTmp = null;
        string mValTmp = null;

        public void AddEntry(string key, string val)
        {
            mEntries.Append(key.Replace("\"",""));
            mEntries.Append("=");
            mEntries.Append(val);
            mEntries.Append(", ");
        }

        public void AddKey(string key)
        {
            mKeyTmp = key;
            if (mKeyTmp != null && mValTmp != null)
            {
                AddEntry(mKeyTmp, mValTmp);
                mKeyTmp = mValTmp = null;
            }
        }

        public void AddValue(string val)
        {
            mValTmp = val;
            if (mKeyTmp != null && mValTmp != null)
            {
                AddEntry(mKeyTmp, mValTmp);
                mKeyTmp = mValTmp = null;
            }
        }

        public override string ToString()
        {
            return "{" + mEntries.ToString() + "}";
        }
    }
}
