using System.Reflection;
using ExampleLibrary;

namespace ExampleApp;

public class Program
{
    public static void Main(string[] args)
    {
        var version = Assembly.GetExecutingAssembly().GetName().Version?.ToString() ?? "Unknown";
        var appName = Assembly.GetExecutingAssembly().GetName().Name ?? "ExampleApp";
        
        Console.WriteLine($"{appName} v{version}");
        Console.WriteLine(new string('-', 40));
        
        var calculator = new Calculator();
        
        if (args.Length == 3)
        {
            if (double.TryParse(args[0], out var num1) && 
                double.TryParse(args[2], out var num2))
            {
                var operation = args[1];
                var result = operation switch
                {
                    "+" => calculator.Add(num1, num2),
                    "-" => calculator.Subtract(num1, num2),
                    "*" => calculator.Multiply(num1, num2),
                    "/" => calculator.Divide(num1, num2),
                    _ => double.NaN
                };
                
                if (!double.IsNaN(result))
                {
                    Console.WriteLine($"{num1} {operation} {num2} = {result}");
                }
                else
                {
                    Console.WriteLine($"Unknown operation: {operation}");
                }
            }
            else
            {
                Console.WriteLine("Invalid numbers provided.");
            }
        }
        else
        {
            Console.WriteLine("Usage: ExampleApp <number1> <operation> <number2>");
            Console.WriteLine("Operations: + - * /");
            Console.WriteLine();
            Console.WriteLine("Example: ExampleApp 10 + 5");
        }
        
        Console.WriteLine();
        Console.WriteLine($"Library Version: {Calculator.GetVersion()}");
    }
}