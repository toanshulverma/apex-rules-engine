/*

Open Source code
Repo: https://github.com/toanshulverma/apex-rules-engine

License
MIT License

Copyright (c) 2021 Sean Cuevo

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

Forked from Repo: https://github.com/seanpat09/apex-rules-engine

*/

@isTest
private with sharing class LogicParser_TEST {

    //1 && 2
    @isTest
    private static void shouldParse_UseCase1() {
        LogicParser.Expression exp =  new LogicParser().parseLogicalExpression('1 && 2');

        exp.set('1', true);
        exp.set('2', true);

        System.assertEquals(true, exp.evaluate());

        exp.set('1', true);
        exp.set('2', false);
        System.assertEquals(false, exp.evaluate());

        exp.set('1', false);
        exp.set('2', true);
        System.assertEquals(false, exp.evaluate());

        exp.set('1', false);
        exp.set('2', false);
        System.assertEquals(false, exp.evaluate());
    }

    //1 || 2
    @isTest
    private static void shouldParse_UseCase2() {
        LogicParser.Expression exp =  new LogicParser().parseLogicalExpression('1 || 2');

        exp.set('1', true);
        exp.set('2', true);
        System.assertEquals(true, exp.evaluate());

        exp.set('1', true);
        exp.set('2', false);
        System.assertEquals(true, exp.evaluate());

        exp.set('1', false);
        exp.set('2', true);
        System.assertEquals(true, exp.evaluate());

        exp.set('1', false);
        exp.set('2', false);
        System.assertEquals(false, exp.evaluate());
    }

    //1 && 2 && 3
    @isTest
    private static void shouldParse_UseCase3() {
        LogicParser.Expression exp =  new LogicParser().parseLogicalExpression('1 && 2 && 3');

        exp.set('1', true);
        exp.set('2', true);
        exp.set('3', true);
        System.assertEquals(true, exp.evaluate());

        exp.set('1', true);
        exp.set('2', true);
        exp.set('3', false);
        System.assertEquals(false, exp.evaluate());
    }

    //(1 && 2) || 3
    @isTest
    private static void shouldParse_UseCase4() {
        LogicParser.Expression exp =  new LogicParser().parseLogicalExpression('( 1 && 2 ) || 3');

        exp.set('1', false);
        exp.set('2', false);
        exp.set('3', true);
        System.assertEquals(true, exp.evaluate());

        exp.set('1', true);
        exp.set('2', true);
        exp.set('3', false);
        System.assertEquals(true, exp.evaluate());

        exp.set('1', true);
        exp.set('2', false);
        exp.set('3', false);
        System.assertEquals(false, exp.evaluate());
    }

    //(1 && 2) || (3 && 4)
    @isTest
    private static void shouldParse_UseCase5() {
        LogicParser.Expression exp =  new LogicParser().parseLogicalExpression('( 1 && 2 ) || ( 3 && 4 )');

        exp.set('1', false);
        exp.set('2', false);
        exp.set('3', true);
        exp.set('4', true);
        System.assertEquals(true, exp.evaluate());

        exp.set('1', true);
        exp.set('2', true);
        exp.set('3', false);
        exp.set('4', false);
        System.assertEquals(true, exp.evaluate());

        exp.set('1', true);
        exp.set('2', false);
        exp.set('3', true);
        exp.set('4', false);
        System.assertEquals(false, exp.evaluate());
    }

    //!( 1 && 2 )
    @isTest
    private static void shouldParse_UseCase6() {
        LogicParser.Expression exp =  new LogicParser().parseLogicalExpression('!( 1 && 2 )');

        exp.set('1', false);
        exp.set('2', false);
        System.assertEquals(true, exp.evaluate());

        exp.set('1', true);
        exp.set('2', true);
        System.assertEquals(false, exp.evaluate());
    }

    //!1
    @isTest
    private static void shouldParse_UseCase7() {
        LogicParser.Expression exp =  new LogicParser().parseLogicalExpression('!1');

        exp.set('1', false);
        System.assertEquals(true, exp.evaluate());

        exp.set('1', true);
        System.assertEquals(false, exp.evaluate());
    }

    //!1
    @isTest
    private static void shouldParse_UseCase8() {
        LogicParser.Expression exp =  new LogicParser().parseLogicalExpression('( 1&&2) ||( 3&&4   )');

        exp.set('1', false);
        exp.set('2', false);
        exp.set('3', true);
        exp.set('4', true);
        System.assertEquals(true, exp.evaluate());

        exp.set('1', true);
        exp.set('2', true);
        exp.set('3', false);
        exp.set('4', false);
        System.assertEquals(true, exp.evaluate());

        exp.set('1', true);
        exp.set('2', false);
        exp.set('3', true);
        exp.set('4', false);
        System.assertEquals(false, exp.evaluate());
    }


    //(1 >= 2) || (3 <= 4)
    @isTest
    private static void shouldParse_UseCase9() {

        LogicParser.Expression exp = new LogicParser().parseLogicalExpression('(1 >= 2) || (3 <= 4)');
        exp.set('1', 6000);
        exp.set('2', 6000);
        exp.set('3', 3000);
        exp.set('4', 4000);
        
        System.assertEquals(true, exp.evaluate());
        
        exp.set('1', 3000);
        exp.set('2', 6000);
        exp.set('3', 3000);
        exp.set('4', 4000);
        System.assertEquals(true, exp.evaluate());

        exp.set('1', 3000);
        exp.set('2', 6000);
        exp.set('3', 5000);
        exp.set('4', 4000);
        System.assertEquals(false, exp.evaluate());
    }

    //(1 = 2) || (3 != 4)
    @isTest
    private static void shouldParse_UseCase10() {

        LogicParser.Expression exp = new LogicParser().parseLogicalExpression('(1 = 2) || (3 != 4)');
        exp.set('1', 6000);
        exp.set('2', 6000);
        exp.set('3', 3000);
        exp.set('4', 4000);
        
        System.assertEquals(true, exp.evaluate());
        
        exp.set('1', 3000);
        exp.set('2', 6000);
        exp.set('3', 3000);
        exp.set('4', 4000);
        System.assertEquals(true, exp.evaluate());

        exp.set('1', 3000);
        exp.set('2', 6000);
        exp.set('3', 5000);
        exp.set('4', 5000);
        System.assertEquals(false, exp.evaluate());
    }

    //String comparison - (1 = 2) || (3 != 4) 
    @isTest
    private static void shouldParse_UseCase11() {

        LogicParser.Expression exp = new LogicParser().parseLogicalExpression('(1 = 2) || (3 != 4)');
        exp.set('1', 'A');
        exp.set('2', 'B');
        exp.set('3', 'C');
        exp.set('4', 'D');
        
        System.assertEquals(true, exp.evaluate());
        
        exp.set('1', 'A');
        exp.set('2', 'A');
        exp.set('3', 'C');
        exp.set('4', 'D');
        System.assertEquals(true, exp.evaluate());

        exp.set('1', 'A');
        exp.set('2', 'B');
        exp.set('3', 'C');
        exp.set('4', 'C');
        System.assertEquals(false, exp.evaluate());
    }

    //String comparison - (1 > 2) || (3 < 4) 
    @isTest
    private static void shouldParse_UseCase12() {

        LogicParser.Expression exp = new LogicParser().parseLogicalExpression('(1 > 2) || (3 < 4)');
        exp.set('1', 'B');
        exp.set('2', 'A');
        exp.set('3', 'C');
        exp.set('4', 'D');
        
        System.assertEquals(true, exp.evaluate());
        
        exp.set('1', 'A');
        exp.set('2', 'A');
        exp.set('3', 'C');
        exp.set('4', 'D');
        System.assertEquals(true, exp.evaluate());

        exp.set('1', 'A');
        exp.set('2', 'B');
        exp.set('3', 'C');
        exp.set('4', 'C');
        System.assertEquals(false, exp.evaluate());
    }


}
