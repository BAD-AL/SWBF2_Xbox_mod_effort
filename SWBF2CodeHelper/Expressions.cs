using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SWBF2CodeHelper
{
    public class Expressions
    {
        public static string ConvertExpressions(string content)
        {
            string[] lines = content.Split("\n".ToCharArray());

            string retVal = ProcessLines(lines);
            return retVal;
        }

        private List<string> mCurrentExpressionList = new List<string>();

        private static string ProcessLines(string[] lines)
        {
            string prevCode = "";
            string line = "";
            Opcode code = Opcode.NONE;
            for (int i = lines.Length - 1; i > -1; i--)
            {
                line = lines[i].Trim();
                code = Operation.GetOpcode(line);
                switch (code)
                {
                    case Opcode.ADD:
                    case Opcode.SUB:
                    case Opcode.DIV:
                    case Opcode.MUL:
                    case Opcode.POW:
                    case Opcode.MOD:
                    case Opcode.UNM:
                        break;
                }

            }
            return "";
        }

    }
}
