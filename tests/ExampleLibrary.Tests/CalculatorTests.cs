using Xunit;

namespace ExampleLibrary.Tests;

public class CalculatorTests
{
    private readonly Calculator _calculator = new();

    [Theory]
    [InlineData(2, 3, 5)]
    [InlineData(-1, 1, 0)]
    [InlineData(0, 0, 0)]
    public void Add_ShouldReturnCorrectSum(double a, double b, double expected)
    {
        var result = _calculator.Add(a, b);
        Assert.Equal(expected, result);
    }

    [Theory]
    [InlineData(5, 3, 2)]
    [InlineData(-1, -1, 0)]
    [InlineData(0, 5, -5)]
    public void Subtract_ShouldReturnCorrectDifference(double a, double b, double expected)
    {
        var result = _calculator.Subtract(a, b);
        Assert.Equal(expected, result);
    }

    [Theory]
    [InlineData(2, 3, 6)]
    [InlineData(-2, 3, -6)]
    [InlineData(0, 5, 0)]
    public void Multiply_ShouldReturnCorrectProduct(double a, double b, double expected)
    {
        var result = _calculator.Multiply(a, b);
        Assert.Equal(expected, result);
    }

    [Theory]
    [InlineData(10, 2, 5)]
    [InlineData(-10, -2, 5)]
    [InlineData(0, 5, 0)]
    public void Divide_ShouldReturnCorrectQuotient(double a, double b, double expected)
    {
        var result = _calculator.Divide(a, b);
        Assert.Equal(expected, result);
    }

    [Fact]
    public void Divide_ByZero_ShouldThrowException()
    {
        Assert.Throws<DivideByZeroException>(() => _calculator.Divide(10, 0));
    }

    [Fact]
    public void GetVersion_ShouldReturnNonEmptyString()
    {
        var version = Calculator.GetVersion();
        Assert.NotNull(version);
        Assert.NotEmpty(version);
        Assert.Contains("ExampleLibrary", version);
    }
}