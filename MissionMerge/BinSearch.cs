using System;
using System.Globalization;
using System.IO;
using System.Text.RegularExpressions;
using System.Collections.Generic;
using System.Text;

namespace MissionMerge
{
    internal class BinSearch
    {
        //private static byte[] data = (byte[])null;

        #region OldMain
        private static int SearchMain(string[] args)
        {
            if (args.Length < 2)
            {
                Console.Error.WriteLine("USAGE: <FileName> <hex search number>");
                Console.Error.WriteLine("OR: <FileName> <hex search number> <hex search number2> offset");
                return 1;
            }
            byte[] data = (byte[])null;
            bool useOffset = false;
            string str = args[0];
            string lower1 = args[1].ToLower();
            if (args.Length == 4)
                useOffset = true;
            if (!File.Exists(str))
            {
                Console.Error.WriteLine("File '{0}' Does not exist!!");
                return 2;
            }
            Match match = new Regex("0x([0-9a-f]+)$").Match(lower1);
            match.Groups[1].ToString();
            if (match == Match.Empty)
            {
                Console.Error.WriteLine("You must pass a valid hex number");
                return 3;
            }
            if (lower1.Length % 2 == 1)
            {
                Console.Error.WriteLine("ERROR!!! You must pass a number with an even amount of digits.");
                return 4;
            }
            try
            {
                long length = new FileInfo(str).Length;
                FileStream fileStream = new FileStream(str, FileMode.Open);
                byte[] buffer = new byte[(int)length];
                fileStream.Read(buffer, 0, (int)length);
                fileStream.Close();
                data = buffer;
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine(ex.ToString());
            }
            byte[] hexNumber1 = BinSearch.GetHexNumber(lower1);
            long num = (long)(data.Length - hexNumber1.Length);
            if (useOffset)
            {
                string lower2 = args[2].ToLower();
                string s = args[3].ToLower();
                if (s.StartsWith("0x"))
                    s = s.Substring(2);
                byte[] hexNumber2 = BinSearch.GetHexNumber(lower2);
                int offset = int.Parse(s, NumberStyles.AllowHexSpecifier);
                for (long location = 0; location < num; ++location)
                {
                    if (BinSearch.Find_Offset(hexNumber1, hexNumber2, offset, location, data))
                        Console.WriteLine("{0:x}", (object)location);
                }
            }
            else
            {
                long location = GetLocationOfGivenBytes(0, hexNumber1, data);
                if(location > -1L)
                    Console.WriteLine("{0:x}", (object)location);
            }
            return 0;
        }
        #endregion

        /// <summary>
        /// Searched through 'data' for the givenBytes.
        /// </summary>
        /// <param name="startLocation">Where to start in 'data'</param>
        /// <param name="givenBytes">the stuff to look for</param>
        /// <param name="data">the big data to look through</param>
        /// <returns>location of the givenBytes, -1L if not found.</returns>
        public static long GetLocationOfGivenBytes(long startLocation, byte[] givenBytes, byte[] data)
        {
            long num = (long)(data.Length - givenBytes.Length);
            for (long location = startLocation; location < num; ++location)
            {
                if (BinSearch.Find(givenBytes, location, data))
                    return location;
            }
            return -1L;
        }

        /// <summary>
        /// Searched through 'data' for the givenBytes.
        /// </summary>
        /// <param name="startLocation">Where to start in 'data'</param>
        /// <param name="givenBytes">the stuff to look for</param>
        /// <param name="data">the big data to look through</param>
        /// <returns>location of the givenBytes, -1L if not found.</returns>
        public static long GetLocationOfGivenBytes(long startLocation, byte[] givenBytes, byte[] data, long maxDistance)
        {
            long retVal = -1L;
            long num = (long)(data.Length - givenBytes.Length);
            for (long location = startLocation; location < num; ++location)
            {
                if (BinSearch.Find(givenBytes, location, data))
                {
                    retVal = location;
                    break;
                }
                else if (maxDistance < location - startLocation)
                    break;
            }
            return retVal;
        }

        /// <summary>
        /// Searched through 'data' for the givenBytes going backwards.
        /// </summary>
        /// <param name="startLocation">Where to start in 'data'</param>
        /// <param name="givenBytes">the stuff to look for</param>
        /// <param name="data">the big data to look through</param>
        /// <param name="maxLookback">the maximum number of bytes to backup.</param>
        /// <returns>location of the givenBytes, -1L if not found.</returns>
        public static long GetLocationOfGivenBytesBackup(long startLocation, byte[] givenBytes, byte[] data, int maxLookback)
        {
            //long num = (long)(data.Length - givenBytes.Length);
            for (long location = startLocation; location > 0; --location)
            {
                if (BinSearch.Find(givenBytes, location, data))
                    return location;
                else if (location < (startLocation - maxLookback))
                    break;
            }
            return -1L;
        }

        public static List<long> GetLocationsOfGivenBytes(long startLocation, byte[] givenBytes, byte[] data)
        {
            List<long> retVal = new List<long>();
            long num = (long)(data.Length - givenBytes.Length);
            for (long location = startLocation; location < num; ++location)
            {
                if (BinSearch.Find(givenBytes, location, data))
                {
                    retVal.Add(location);
                    location += givenBytes.Length;
                }
            }
            return retVal;
        }

        private static bool Find(byte[] hexNumber, long location, byte[] data)
        {
            int index = 0;
            while (index < hexNumber.Length && (int)hexNumber[index] == (int)data[location + (long)index])
                ++index;
            return index == hexNumber.Length;
        }

        private static bool Find_Offset(byte[] hexNumber, byte[] hexNumber2, int offset, long location, byte[] data)
        {
            if (BinSearch.Find(hexNumber, location, data) && location + (long)offset + (long)hexNumber2.Length < (long)data.Length)
                return BinSearch.Find(hexNumber2, location + (long)offset, data);
            return false;
        }

        private static byte[] GetHexNumber(string h)
        {
            string str = h.Substring(2);
            byte[] numArray = new byte[str.Length / 2];
            int index = 0;
            int startIndex = 0;
            while (startIndex < str.Length)
            {
                string s = str.Substring(startIndex, 2);
                numArray[index] = byte.Parse(s, NumberStyles.AllowHexSpecifier);
                ++index;
                startIndex += 2;
            }
            return numArray;
        }

        public static byte[] GetArrayChunk(byte[] bigData, long start, long len)
        {
            byte[] retVal = new byte[len];
            Array.Copy(bigData, start, retVal, 0, len);
            return retVal;
        }

        public static string GetBinaryRepresentationString(byte[] data)
        {
            StringBuilder sb = new StringBuilder(data.Length * 3);
            int charsOnLine = 0;
            foreach (byte b in data)
            {
                if (charsOnLine == 16)
                {
                    sb.Append("\n");
                    charsOnLine = 0;
                }
                sb.AppendFormat("{0:x2} ", b);
            }
            return sb.ToString();
        }

        internal static string GetByteString(long location, byte[] data, int numBytes)
        {
            char c = '.';
            StringBuilder b = new StringBuilder(numBytes);
            if (location < 0) location = 0;

            for (long l = location; l < location + numBytes; l++)
            {
                if (data[l] != 0)
                    c = (char)data[l];
                else
                    c = '.';
                b.Append(c);
            }
            return b.ToString();
        }
    }
}