using Xunit;

namespace ExampleApp.Tests;

public class ProgramTests
{
    [Fact]
    public void Main_ShouldExecuteWithoutError()
    {
        // Arrange
        var args = new[] { "10", "+", "5" };
        
        // Act & Assert - Just verify it doesn't throw
        Program.Main(args);
    }
}