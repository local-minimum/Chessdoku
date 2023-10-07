using System;
using Google.OrTools.Sat;

class Program
{

    private const int EMPTY = 0;
    private const int W_PAWN = 1;
    private const int W_ROOK = 2;
    private const int W_BISHOP = 3;
    private const int W_KNIGHT = 4;
    private const int W_QUEEN = 5;
    private const int W_KING = 6;
    private const int B_PAWN = 7;
    private const int B_ROOK = 8;
    private const int B_BISHOP = 9;
    private const int B_KNIGHT = 10;
    private const int B_QUEEN = 11;
    private const int B_KING = 12;

    private const int LOWER_BOUND = EMPTY;
    private const int UPPER_BOUND = B_KING;

    private const int SIZE = 12;


    public static void Main(string[] args)
    {
        // https://developers.google.com/optimization/cp/cp_example

        Console.WriteLine("Begin generation");

        CpModel model = new();

        IntVar[][] board = CreateBoard();
        PopulateBoard(model, board);

        CpSolver solver = new();
        CpSolverStatus status = solver.Solve(model);

        if (status == CpSolverStatus.Optimal || status == CpSolverStatus.Feasible)
        {
            Console.WriteLine("Solution found.");
        }
        else
        {
            Console.WriteLine("No solution found.");
        }

        Console.WriteLine("End generation");
    }

    private static void PopulateBoard(CpModel model, IntVar[][] board)
    {
        for (int i = 0; i < SIZE; i++)
        {
            for (int j = 0; j < SIZE; j++)
            {
                board[i][j] = model.NewIntVar(LOWER_BOUND, UPPER_BOUND, $"cell_{i + 1}_{j + 1}");
            }
        }
    }

    private static IntVar[][] CreateBoard()
    {
        IntVar[][] board = new IntVar[SIZE][];
        for (int i = 0; i < SIZE; i++)
        {
            board[i] = new IntVar[SIZE];
        }
        return board;
    }

}