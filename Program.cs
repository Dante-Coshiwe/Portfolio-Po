using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Programming182
{
    class Applicant
    {
        public string Name { get; set; }
        public int Age { get; set; }
        public int JoinDate { get; set; } // in months
        public int MembershipRank { get; set; }
        public int SmoothiesPurchased { get; set; }
        public int TreadmillDistance { get; set; }
        public string EmploymentStatus { get; set; }
        public string FavouriteSmoothie { get; set; }
        public int SmoothiesConsumed { get; set; }
        public bool IsQualified { get; set; } // for stats
    }

    internal class Program
    {
        enum Menu
        {
            Details = 1,
            CheckQualification,
            ShowStats,
            Exit
        }

        static List<Applicant> applicants = new List<Applicant>();

        static void Main(string[] args)
        {
            bool running = true;

            while (running)
            {
                Console.WriteLine("\n @FitForge Wellness Menu@ ");
                Console.WriteLine("1. Capture Member Details");
                Console.WriteLine("2. Check Wellness Reward Qualification");
                Console.WriteLine("3. Show FitForge Stats");
                Console.WriteLine("4. Exit");
                Console.Write("Choose an option: ");

                if (!int.TryParse(Console.ReadLine(), out int option) || option < 1 || option > 4)
                {
                    Console.WriteLine("Invalid option. Please choose 1 to 4.");
                    continue;
                }

                Menu selection = (Menu)option;

                switch (selection)
                {
                    case Menu.Details:
                        CaptureDetails();
                        break;

                    case Menu.CheckQualification:
                        CheckAllQualifications();
                        break;

                    case Menu.ShowStats:
                        ShowStats();
                        break;

                    case Menu.Exit:
                        Console.WriteLine("Goodbye!");
                        running = false;
                        break;
                }
            }
        }

        static void CaptureDetails()
        {
            bool adding = true;

            while (adding)
            {
                Applicant applicant = new Applicant();

                Console.Write("Enter Name and Surname: ");
                applicant.Name = Console.ReadLine();
                Console.Beep();

                Console.Write("Enter Age: ");
                applicant.Age = int.Parse(Console.ReadLine());
                Console.Beep();

                Console.Write("Enter Join Date in Months: ");
                applicant.JoinDate = int.Parse(Console.ReadLine());
                Console.Beep();

                Console.Write("Enter Membership Rank: ");
                applicant.MembershipRank = int.Parse(Console.ReadLine());
                Console.Beep();

                Console.Write("Enter Number of Smoothies Purchased: ");
                applicant.SmoothiesPurchased = int.Parse(Console.ReadLine());
                Console.Beep();

                Console.Write("Enter Treadmill Distance (km): ");
                applicant.TreadmillDistance = int.Parse(Console.ReadLine());
                Console.Beep();

                Console.Write("Are you or your guardian employed? (Yes/No): ");
                applicant.EmploymentStatus = Console.ReadLine().Trim().ToUpper();
                Console.Beep();

                Console.Write("Enter Favourite Smoothie: ");
                applicant.FavouriteSmoothie = Console.ReadLine();
                Console.Beep();

                Console.Write("Enter Total Smoothies Consumed: ");
                applicant.SmoothiesConsumed = int.Parse(Console.ReadLine());
                Console.Beep();

                applicant.IsQualified = false; // default, will be updated later
                applicants.Add(applicant);
                Console.Beep();

                Console.Write("Do you want to enter another applicant? (Y/N): ");
                string more = Console.ReadLine().Trim().ToUpper();
                if (more != "Y") adding = false;
            }
        }

        static void CheckAllQualifications()
        {
            if (applicants.Count == 0)
            {
                Console.WriteLine("No applicants found. Please capture details first.");
                return;
            }

            foreach (var applicant in applicants)
            {
                int averageSmoothies = applicant.SmoothiesConsumed / Math.Max(1, applicant.JoinDate);

                bool isEmployed = applicant.EmploymentStatus == "YES";
                bool hasBeenMember2Years = applicant.JoinDate >= 24;
                bool meetsPerformance = applicant.MembershipRank > 2000 || applicant.TreadmillDistance > 20;
                bool healthySmoothieIntake = averageSmoothies >= 4 && averageSmoothies <= 20;


                if ((isEmployed || applicant.Age < 18) &&
                    hasBeenMember2Years &&
                    meetsPerformance &&
                    healthySmoothieIntake)
                {
                    applicant.IsQualified = true;
                    Console.WriteLine($"{applicant.Name}:  Qualified");
                }
                else
                {
                    applicant.IsQualified = false;
                    Console.WriteLine($"{applicant.Name}:  Not Qualified");
                }
            }
        }

        static void ShowStats()
        {
            int total = applicants.Count;
            int qualified = 0;

            foreach (var applicant in applicants)
            {
                if (applicant.IsQualified) qualified++;
            }

            int notQualified = total - qualified;

            Console.WriteLine("\n@ FitForge Stats @");
            Console.WriteLine($"Total Applicants: {total}");
            Console.WriteLine($"Qualified: {qualified}");
            Console.WriteLine($"Not Qualified: {notQualified}");
        }
    }
}


