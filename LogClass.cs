using System;
using System.Collections.Generic;   // <-- for IComparer

namespace MyLogger {

    public enum LogType {
        VERB,
        WARN,
        INFO
    }

    public class Payload {
        
        // properties
        public string ComputerName = Environment.MachineName;
        public DateTime Timestamp  = DateTime.UtcNow;
        public LogType Type;
        public string Message;

        // constructors
        public Payload() {}
        public Payload(LogType type,string message) {
            this.Type    = type;
            this.Message = message;
        }

        // methods
        public static Payload Empty(LogType type) {
            Payload obj = new Payload {
                Type    = type,
                Message = string.Empty
            };
            return obj;
        }

        public override string ToString() {
            string time   = this.Timestamp.ToString("HH:mm:ss");
            string output = string.Format(@"{0} [{1}] {2}",time,this.Type,this.Message);
            return output;
        }
    }

    // Comparer-based class for sorting Payload items, but only based on the Timestamp property 
    public class PayloadComparer : IComparer<Payload> {

        // properties
        public bool Descending;   // <-- by default this is set to false

        // constructors
        public PayloadComparer() {}
        public PayloadComparer(bool descending) {this.Descending = descending;}

        // method
        public int Compare(Payload a, Payload b) {
            int Result;
            if      (a.Timestamp == b.Timestamp) {Result =  0;}
            else if (a.Timestamp <  b.Timestamp) {Result = -1;}
            else                                 {Result =  1;}

            if (this.Descending) {Result *= -1;}

            return Result;
         }
    } //LogPayloadComparer
}