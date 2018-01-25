using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SWBF2CodeHelper
{

    public class LuaChunk
    {
        public int LastLine = -1; // hacky

        private int IndentSpaces = 0;

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

        private String mGlobalName = null;
        protected List<LuaChunk> mChildren = new List<LuaChunk>();

        protected string mAssignmentLvalue = null;

        public string ConstantValue = null;

        public LuaChunk ParentChunk { get; private set; }

        public string GlobalName { set { mGlobalName = value; } get { return mGlobalName; } }

        internal void AddAssignmentLvalue(string name)
        {
            mAssignmentLvalue = name;
        }

        internal void SetCall()
        {
            mType = LuaType.FUNCTION_CALL;
        }

        internal virtual void AddConstant(LuaChunk p)
        {
            mChildren.Add(p);
        }

        internal void AddChunk(LuaChunk child)
        {
            if (child != null)
            {
                if (child.ParentChunk != null)
                    child.ParentChunk.mChildren.Remove(child);

                child.ParentChunk = this;
                mChildren.Add(child);
            }
        }

        internal LuaChunk GetOlderSipling()
        {
            if (ParentChunk.mChildren.Count > 1)
            {
                for (int i = ParentChunk.mChildren.Count - 1; i > 1; i--)
                    if (ParentChunk.mChildren[i] == this)
                        return ParentChunk.mChildren[i - 1];
            }
            return null;
        }

        public override string ToString()
        {
            if (LuaType == LuaType.CONSTANT)
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
                if (this.mAssignmentLvalue != null)
                    builder.Append(mAssignmentLvalue + " = ");
                builder.Append(mGlobalName);
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
                    builder.Append(arg);
                    builder.Append(",");
                }
                if (mChildren.Count > 0) builder.Remove(builder.Length - 1, 1);
                builder.Append(")");
                if (ParentChunk != null && ParentChunk.LuaType != LuaType.FUNCTION_CALL)
                    builder.Append("\n");
            }
            else if (this.LuaType == LuaType.SIMPLE_ASSIGNMENT)
            {
                if (mChildren.Count > 0)
                    builder.Append(string.Format("{0} = {1}\n", mAssignmentLvalue, mChildren[0]));
                else if (ConstantValue != null)
                    builder.Append( string.Format("{0} = {1}\n", mAssignmentLvalue, ConstantValue));
                else
                    throw new Exception("Error with simple assignment!!!");
            }
            else if (mChildren.Count > 0)
            {
                foreach (LuaChunk child in mChildren)
                    builder.Append(child.ToString());// +"\n";
            }
            else if (mGlobalName != null)
                builder.Append( mGlobalName);

            return builder.ToString();
        }

        // Take the last 2 children and the op, create an Expression
        internal LuaChunk ApplyExpression(Opcode code)
        {
            if (mChildren.Count > 1)
            {
                LuaExpression expr = new LuaExpression()
                {
                    Operation = code,
                    LValue = mChildren[mChildren.Count - 1],
                    RValue = mChildren[mChildren.Count - 2]
                };
                mChildren.RemoveRange(mChildren.Count - 2, 2);
                AddChunk(expr);
                return expr;
            }
            throw new Exception("the code is wrong! fix it!!!");
        }

        internal LuaChunk ApplyExpression(LuaExpression arg)
        {
            if (mChildren.Count > 0)
            {
                LuaExpression ex = mChildren[mChildren.Count - 1] as LuaExpression;
                if (ex != null)
                {
                    arg.RValue = ex;
                    ReplaceChunk(ex, arg);
                    return ex;
                }
            }
            throw new Exception("the code is wrong! fix it!!!");
        }

        internal void ReplaceChunk(LuaChunk child, LuaChunk replacement)
        {
            int index = mChildren.IndexOf(child);
            if (index > -1)
            {
                replacement.ParentChunk = this;
                mChildren.Insert(index, replacement);
                mChildren.RemoveAt(index + 1);
            }
        }

        public LuaChunk Clone()
        {
            LuaChunk retVal = this.MemberwiseClone() as LuaChunk;
            if( retVal.mChildren.Count > 0 )
                retVal.mChildren = new List<LuaChunk>();
            retVal.ParentChunk = null;
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

        public void SetList()
        {
            ListMode = true;
        }

        public override string ToString()
        {
            StringBuilder bu = new StringBuilder();
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
                    bu.Append(kvp.Key);
                    bu.Append(" = ");
                    bu.Append(kvp.Value);
                    bu.Append(", ");
                }
            }
            if (mEntries.Count > 0 || (ListMode && mChildren.Count > 0))
                bu.Remove(bu.Length - 2, 2);
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
                case Opcode.EQ: op = "="; break;
                case Opcode.LT: op = "<"; break;
                case Opcode.LE: op = "<="; break;
                case Opcode.ADD: op = "+"; break;
                case Opcode.SUB: op = "-"; break;
                case Opcode.MUL: op = "*"; break;
                case Opcode.DIV: op = "/"; break;
                //case Opcode.MOD: op = "%"; break;
                case Opcode.POW: op = "^"; break;
            }
            string assignVal = mAssignmentLvalue != null ? mAssignmentLvalue+" = " : "";
            string retVal = String.Format("{0}{1} {2} {3}", assignVal, LValue, op, RValue);
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
                bu.Append("end\n");
            }
            else
                bu.Append("end\n");
            return bu.ToString();
        }
    }

    public class LuaFunction : LuaChunk
    {
        public int NumberOfPraams { get; set; }

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
            bu.Append("\nfunction ");
            bu.Append(Name);
            bu.Append("(");
            for (int i = 0; i < NumberOfPraams; i++)
            {
                bu.Append(Name + "_param_" + i + ", ");
            }
            if (NumberOfPraams > 0)
                bu.Remove(bu.Length - 2, 2);
            bu.Append(")\n");
            bu.Append(Body.ToString());
            bu.Append("end\n");
            return bu.ToString();
        }
    }

}
