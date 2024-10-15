classdef TestFactorialFunction < matlab.unittest.TestCase
    methods(Test)
        function testPositiveNumber(testCase)
            % Test factorial of a positive number
            actSolution = factorial_function(5);
            expSolution = 120;
            testCase.verifyEqual(actSolution, expSolution);
        end

        function testZero(testCase)
            % Test factorial of zero
            actSolution = factorial_function(0);
            expSolution = 1;
            testCase.verifyEqual(actSolution, expSolution);
        end

        function testOne(testCase)
            % Test factorial of one
            actSolution = factorial_function(1);
            expSolution = 1;
            testCase.verifyEqual(actSolution, expSolution);
        end

        function testNegativeNumber(testCase)
            % Test factorial of a negative number (should throw error)
            testCase.verifyError(@() factorial_function(-1), 'MATLAB:factorial_function:InputMustBeNonNegative');
        end
    end
end
