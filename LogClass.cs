using System;

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
}