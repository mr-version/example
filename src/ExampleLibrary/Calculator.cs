using System.Reflection;

namespace ExampleLibrary;

public class Calculator
{
    public double Add(double a, double b) => a + b;
    
    public double Subtract(double a, double b) => a - b;
    
    public double Multiply(double a, double b) => a * b;
    
    public double Divide(double a, double b)
    {
        if (b == 0)
        {
            throw new DivideByZeroException("Cannot divide by zero.");
        }
        return a / b;
    }
    
    public static string GetVersion()
    {
        var assembly = Assembly.GetExecutingAssembly();
        var version = assembly.GetName().Version?.ToString() ?? "Unknown";
        var name = assembly.GetName().Name ?? "ExampleLibrary";
        return $"{name} v{version}";
    }
}