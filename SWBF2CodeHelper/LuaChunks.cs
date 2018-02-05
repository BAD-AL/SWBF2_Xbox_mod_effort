using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SWBF2CodeHelper
{

    public class LuaChunk
    {
        public int LastLine = -1; // hacky

        private LuaType mType = LuaType.NONE;
        public virtual LuaType LuaType
        {
            get
            {
                if (mType != LuaType.NONE) return mType;

                if (this.mAssignmentLvalue != null) return LuaType.SIMPLE_ASSIGNMENT;

                if (this.ConstantValue != null) return LuaType.CONSTANT;

                return LuaType.NONE;
            }
            protected set { mType = value; }
        }

        public string Self { get; set; }

        public string GetTable { get; set; }

        protected List<LuaChunk> mChildren = new List<LuaChunk>();

        protected string mAssignmentLvalue = null;

        public string ConstantValue = null;

        public LuaChunk ParentChunk { get; private set; }

        public string GlobalName { get; set; }

        public string LocalName { get; set; }

        internal void AddAssignmentLvalue(string name)
        {
            mAssignmentLvalue = name;
        }

        internal void SetCall()
        {
            mType = LuaType.FUNCTION_CALL;
        }

        internal void AddChunk(LuaChunk child)
        {
            if (child != null)
            {
                if (child.ParentChunk != null)
                    child.ParentChunk.mChildren.Remove(child);
                if (child == this)
                    Program.ReportError(this.GlobalName, "Adding self as a child! Fix the code!!!", null);
                child.ParentChunk = this;
                mChildren.Add(child);
            }
        }

        protected string GetIndenting()
        {
            int spaces = -1;
            LuaChunk pops = ParentChunk;
            while (pops != null)
            {
                spaces++;
                pops = pops.ParentChunk;
            }
            spaces *= 2;
            if (spaces < 0) spaces = 0;
            string retVal = new String(' ', spaces);
            return retVal;
        }

        public override string ToString()
        {
            if (LuaType == LuaType.CONSTANT && LocalName == null)
            {
                string retVal = ConstantValue;
                
                if (retVal != null && retVal.Length > 0 && retVal[0] == '"')
                {
                    retVal = retVal.Replace("\\", "\\\\");
                }
                return retVal;
            }

            StringBuilder builder = new StringBuilder();
            if (this.LuaType == LuaType.FUNCTION_CALL)
            {
                builder.Append(GetIndenting());

                if (this.mAssignmentLvalue != null)
                    builder.Append(mAssignmentLvalue + " = ");
                builder.Append(GlobalName);
                if (this.Self != null)
                {
                    builder.Append(":");
                    builder.Append(this.Self);
                }
                else if (this.GetTable != null)
                {
                    builder.Append(".");
                    builder.Append(this.GetTable);
                }
                builder.Append("(");
                foreach (LuaChunk arg in mChildren)
                {
                    builder.Append(arg.ToString().Trim());
                    builder.Append(",");
                }
                if (mChildren.Count > 0) builder.Remove(builder.Length - 1, 1);
                builder.Append(")");
                if (ParentChunk != null && ParentChunk.LuaType != LuaType.FUNCTION_CALL)
                    builder.Append("\n");
            }
            else if (this.LuaType == LuaType.SIMPLE_ASSIGNMENT)
            {
                builder.Append(GetIndenting());
                if (mChildren.Count > 0)
                    builder.Append(string.Format("{0} = {1}\n", mAssignmentLvalue, mChildren[0]));
                else if (ConstantValue != null)
                    builder.Append(string.Format("{0} = {1}\n", mAssignmentLvalue, ConstantValue));
                else if (GlobalName != null)
                    builder.Append(string.Format("{0} = {1}\n", mAssignmentLvalue, GlobalName));
                else
                    Program.ReportError(this.mAssignmentLvalue, "Error with simple assignment!!!", null);
            }
            else if (mChildren.Count > 0)
            {
                foreach (LuaChunk child in mChildren)
                    if (child == this)
                        Program.ReportError(this.GlobalName, "How did this get in here!! Child == self???", null);
                    else
                        builder.Append(child.ToString());// +"\n";
            }
            else if (GlobalName != null)
                builder.Append(GlobalName);
            else if (LocalName != null)
                builder.Append(LocalName);

            return builder.ToString();
        }

        internal void ReplaceChunk(LuaChunk child, LuaChunk replacement)
        {
            int index = mChildren.IndexOf(child);
            if (index > -1)
            {
                if (replacement == this)
                    Program.ReportError(this.GlobalName, "Cannot add self as a Child!!!", null);
                replacement.ParentChunk = this;
                mChildren.Insert(index, replacement);
                mChildren.RemoveAt(index + 1);
            }
        }

        public LuaChunk Clone()
        {
            //LuaChunk retVal = this.MemberwiseClone() as LuaChunk;
            //if( retVal.mChildren.Count > 0 )
            //    retVal.mChildren = new List<LuaChunk>();
            //retVal.ParentChunk = null;

            LuaChunk retVal = new LuaChunk()
            {
                ConstantValue = this.ConstantValue,
                GetTable = this.GetTable,
                Self = this.Self,
                GlobalName = this.GlobalName,
                mType = this.mType,
                LocalName = this.LocalName
            };

            return retVal;
        }
    }

    public class LuaTable : LuaChunk
    {
        Dictionary<string, LuaChunk> mEntries = new Dictionary<string, LuaChunk>();
        
        public Boolean ListMode { get; set; }

        string mKeyTmp = null;
        LuaChunk mValTmp = null;

        /// <summary>
        /// A 'LuaTable' 
        /// </summary>
        /// <param name="listMode">true if this is actually going to be a list.</param>
        public LuaTable( bool listMode ) 
        {
            this.LuaType = LuaType.TABLE;
            this.ListMode = listMode;
        }

        public override LuaType LuaType { get { return LuaType.TABLE; } protected set { base.LuaType = value; } }

        public void AddEntry(string key, LuaChunk val)
        {
            //if (!ListMode)
            {
                this.AddChunk(val);
                mEntries.Add(key.Replace("\"", ""), val);
            }
            //else
            //    throw new Exception("This table is in list mode!");
        }

        public void AddKey(string key)
        {
            mKeyTmp = key;
            if (mKeyTmp != null && mValTmp != null)
            {
                AddEntry(mKeyTmp, mValTmp);
                mKeyTmp = null;
                mValTmp = null;
            }
        }

        public void AddValue(LuaChunk val)
        {
            if (ListMode)
            {
                AddChunk(val);
            }
            else
            {
                mValTmp = val;
                this.AddChunk(val);
                if (mKeyTmp != null && mValTmp != null)
                {
                    AddEntry(mKeyTmp, mValTmp);
                    mKeyTmp = null;
                    mValTmp = null;
                }
            }
        }

        public override string ToString()
        {
            StringBuilder bu = new StringBuilder();
            bool dropLine = false;
            bu.Append(GetIndenting());//check this
            if (this.mAssignmentLvalue != null)
                bu.Append(mAssignmentLvalue + " = ");
            bu.Append("{ ");
            if (ListMode)
            {
                foreach (LuaChunk kid in mChildren)
                {
                    bu.Append(kid);
                    bu.Append(", ");
                }
            }
            else
            {
                foreach (KeyValuePair<string, LuaChunk> kvp in mEntries)
                {
                    if (kvp.Value.LuaType == LuaType.TABLE)
                        bu.Append("\n");
                    if (kvp.Value.LuaType == LuaType.TABLE)
                    {
                        bu.Append(GetIndenting() + "  ");
                        dropLine = true;
                    }
                    bu.Append(kvp.Key);
                    bu.Append(" = ");
                    bu.Append(kvp.Value);
                    bu.Append(", ");
                }
            }
            if (mEntries.Count > 0 || (ListMode && mChildren.Count > 0))
                bu.Remove(bu.Length - 2, 2);

            if (dropLine)
            {
                bu.Append("\n");
                bu.Append(GetIndenting());
            }
            bu.Append(" }");
            if (ParentChunk.LuaType != LuaType.TABLE && ParentChunk.LuaType != LuaType.FUNCTION_CALL )
                bu.Append("\n");
            return bu.ToString();
        }

    }

    public class LuaExpression : LuaChunk
    {
        public Opcode Operation { get; set; }

        public LuaChunk LValue { get; set; }

        public LuaChunk RValue { get; set; }

        public override LuaType LuaType { get { return LuaType.EXPRESSION; } protected set { } }

        public override string ToString()
        {
            string op = "";
            switch (Operation)
            {
                case Opcode.EQ: op = "==";   break;
                case Opcode.LT: op = "<";    break;
                case Opcode.LE: op = "<=";   break;
                case Opcode.ADD: op = "+";   break;
                case Opcode.SUB: op = "-";   break;
                case Opcode.MUL: op = "*";   break;
                case Opcode.DIV: op = "/";   break;
                case Opcode.AND: op = "and"; break;
                case Opcode.OR: op = "or";   break;
                case Opcode.POW: op = "^";   break;
            }
            string assignVal = mAssignmentLvalue != null ? mAssignmentLvalue+" = " : "";
            string retVal = String.Format("{0}{1} {2} {3}", assignVal, LValue.ToString(), op, RValue.ToString());
            if (mAssignmentLvalue != null )
                retVal += "\n";
            if (assignVal == "" && LocalName != null)
                return LocalName;
            return retVal;
        }
    }

    public class IfStatement : LuaChunk
    {
        private LuaChunk mExpression = null;
        public LuaChunk Expression 
        {
            get { return mExpression; }
            set
            {
                if (mExpression != null)
                    mChildren.Remove(mExpression);
                mExpression = value;
                AddChunk(mExpression);
            }
        }

        private LuaChunk mThenChunk = null;
        public LuaChunk ThenChunk 
        {
            get { return mThenChunk; }
            set
            {
                if (mThenChunk != null)
                    mChildren.Remove(mThenChunk);
                mThenChunk = value;
                AddChunk(mThenChunk);
            }
        }

        private LuaChunk mElseChunk = null;
        public LuaChunk ElseChunk 
        {
            get { return mElseChunk; }
            set
            {
                if (mElseChunk != null)
                    mChildren.Remove(mElseChunk);
                mElseChunk = value;
                AddChunk(mElseChunk);
            }
        }

        public override LuaType LuaType
        {
            get { return LuaType.IF_STATEMENT; } protected set { }
        }

        public override string ToString()
        {
            StringBuilder bu = new StringBuilder();
            bu.Append(string.Format("if {0} then\n", Expression));
            bu.Append(ThenChunk);
            if (ElseChunk != null)
            {
                bu.Append("else\n");
                bu.Append(ElseChunk);
            }
            bu.Append("end\n");
            return bu.ToString();
        }
    }

    public class LuaFunction : LuaChunk
    {
        public List<LuaChunk> UpValues = new List<LuaChunk>();

        public string ClosureNumber { get; set;  }

        private int mNumberOfPraams = 0;

        public int NumberOfPraams
        {
            get { return mNumberOfPraams; } 
            set
            {
                mNumberOfPraams = value;
                if (mNumberOfPraams > 0)
                {
                    string n = GlobalName != null ? GlobalName : Name;
                }
            }
        }

        private LuaChunk mBody = null;
        public LuaChunk Body 
        { 
            get{ return mBody;}
            set
            {
                if( mBody != null)
                    mChildren.Remove(mBody);
                mBody = value;
                AddChunk(mBody);
            }
        }

        public string Name { get; set; }

        public override LuaType LuaType { get { return LuaType.FUNCTION_DEF; } protected set { } }

        public override string ToString()
        {
            StringBuilder bu = new StringBuilder();
            if (Name != null)
                bu.Append(String.Format("\nfunction {0}(", Name.Replace("\"", "")));
            else if (mAssignmentLvalue != null)
                bu.Append(String.Format("{0} = function (", mAssignmentLvalue.Replace("\"", "")));
            else
                Program.ReportError("Function un-nammed", "ToString on a function; function has no name!!!", null);

            for (int i = 0; i < NumberOfPraams; i++)
            {
                bu.Append(Name + "Param" + i + ", ");
            }
            if (NumberOfPraams > 0)
                bu.Remove(bu.Length - 2, 2);
            bu.Append(")\n");
            if (Body != null)
            {
                bu.Append(Body.ToString());
                bu.Append("end\n");
            }
            return bu.ToString();
        }
    }

    public class LuaReturn : LuaChunk
    {
        public LuaChunk ReturnValue { get; set; }

        public override string ToString()
        {
            return String.Format("{0}return {1}\n",GetIndenting(),  ReturnValue.ToString().Trim() );
        }
    }

    public class LuaConcat : LuaChunk
    {
        public override string ToString()
        {
            StringBuilder builder = new StringBuilder();
            if (mAssignmentLvalue != null)
            {
                builder.Append(GetIndenting());
                builder.Append(mAssignmentLvalue);
                builder.Append(" = ");
            }
            foreach (LuaChunk child in mChildren)
            {
                builder.Append(child.ToString());
                builder.Append(" .. ");
            }
            builder.Remove(builder.Length - 4, 4);
            if (mAssignmentLvalue != null)
                builder.Append("\n");
            return builder.ToString();
        }
    }

}
