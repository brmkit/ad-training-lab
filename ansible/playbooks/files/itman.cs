using System;
using System.ServiceProcess;

namespace itmansvc
{
    class Program : ServiceBase
    {
        static void Main(string[] args)
        {
            ServiceBase[] ServicesToRun;
            ServicesToRun = new ServiceBase[]
            {
                new Program()
            };
            ServiceBase.Run(ServicesToRun);
        }

        public Program()
        {
            ServiceName = "itmansvc";
        }

        protected override void OnStart(string[] args)
        {
            Console.WriteLine("yeah, it's up to you to define what i'm really doing here.");
            base.OnStart(args);
        }

        protected override void OnStop()
        {
            Console.WriteLine("done.");
            base.OnStop();
        }
    }
}
