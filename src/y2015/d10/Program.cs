using System;
using System.Text;
                    
public class Program
{
    public static void Main()
    {
        string input = "1321131112";
        
        for (int i = 0; i < 40; i++)
            input = Transform(input);
        
        Console.WriteLine(input.Length);

        // Do the next 10 to reach 50
        for (int i = 0; i < 10; i++)
            input = Transform(input);

        Console.WriteLine(input.Length);
    }
    
    private static string Transform(string str)
    {
        StringBuilder sb = new StringBuilder();
        
        int counter = 0;
        char current = str[0];
        
        foreach (char c in str)
        {
            if (c != current)
            {
                sb.Append(counter);
                sb.Append(current);
                counter = 0;
                current = c;
            }
            
            counter++;
        }

        sb.Append(counter);
        sb.Append(current);
        
        return sb.ToString();
    }
}
