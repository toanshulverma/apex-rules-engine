/*

Open Source code
Repo: https://github.com/seanpat09/apex-rules-engine

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



//--------------------- FORK DETAILS

Repo: https://github.com/toanshulverma/apex-rules-engine
Additional Capabilities: 
1. Additional support for comparison expressions (<, >, =, !=)

*/

public with sharing class LogicParser {
    private Integer index = 0;
    public Expression parseLogicalExpression(String logicalExpression) {
        List<String> tokens = normalizeLogicalExpression(logicalExpression).split(' ');
        Expression exp = buildExpression(tokens);
        return exp;
    }

    private String normalizeLogicalExpression(String exp){
        exp = exp.replace(' ', '');
        
        //Find the following tokens: number, open parens, close parens, &&, ||, !
        Pattern p = Pattern.compile('(\\d+|\\(|\\)|\\!(=)|\\=|&{2}|\\|{2}|\\!|\\<|\\>)');
        Matcher pm = p.matcher( exp );

        String formattedExpression = '';
        while(pm.find()) {
            formattedExpression += pm.group() + ' ';
        }

        // system.debug(formattedExpression);
        return formattedExpression.trim();
    }

    private Expression buildExpression(List<String> tokens) {
        Composite baseComposite;
        Expression stagedVariable;
        NotComposite stagedNotComposite;

        while(this.index < tokens.size()) {
            String token = tokens[this.index];

            // system.debug('>>>> Current token: ' + token);
            if (token == '!') {
                stagedNotComposite = new NotComposite();

            }
            else if (token == '(') {
                this.index++;
                Expression childExpression = buildExpression(tokens);
                if(stagedNotComposite != null) {
                    childExpression = stagedNotComposite.add(childExpression);
                }
                if (baseComposite == null) {
                    stagedVariable = childExpression;

                } else {
                    baseComposite.add(childExpression);
                }
            }
            else if (token == ')') {
                return baseComposite;

            }
            else if (token == '&&') {
                if (baseComposite == null) {
                    baseComposite = new AndComposite();
                    baseComposite.add(stagedVariable);
                    stagedVariable = null;
                }
            }
            else if (token == '||') {
                if (baseComposite == null) {
                    baseComposite = new OrComposite();
                    baseComposite.add(stagedVariable);
                    stagedVariable = null;
                }
            }
            else if (token == '>') {
                if (baseComposite == null) {
                    baseComposite = new GreaterThanComposite();
                    baseComposite.add(stagedVariable);
                    stagedVariable = null;
                }
            }
            else if (token == '<') {
                if (baseComposite == null) {
                    baseComposite = new LessThanComposite();
                    baseComposite.add(stagedVariable);
                    stagedVariable = null;
                }
            }
            else if (token == '=') {
                if (baseComposite == null) {
                    baseComposite = new EqualsComposite();
                    baseComposite.add(stagedVariable);
                    stagedVariable = null;
                }
            }
            else if (token == '!=') {
                if (baseComposite == null) {
                    baseComposite = new NotEqualsComposite();
                    baseComposite.add(stagedVariable);
                    stagedVariable = null;
                }
            } 
            else {
                Expression newVariable;

                if(stagedNotComposite != null) {
                    newVariable = stagedNotComposite.add(new Variable(token));
                } else {
                    newVariable = new Variable(token);
                }

                if(baseComposite == null) {
                    stagedVariable = newVariable;
                } else {
                    baseComposite.add(newVariable);
                }
            }
            this.index++;
        }

        return baseComposite == null ? stagedVariable : baseComposite;
    }

    public interface Expression {
        Expression add(Expression expr);
        Expression set(String name, Object value);
        Object evaluate(); 
    }

    public abstract class Composite implements Expression{
        public List<Expression> children {get; private set;}
        public Composite(){ this.children = new List<Expression>(); }
        public Expression add(Expression expr){
            children.add(expr); return this;
        }
        public Expression set(String name, Object value){
            for(Expression expr : children) {
                expr.set(name,value);
            }
            return this;
        }
        public abstract Object evaluate();
        public Boolean hasChildren{get{ return !children.isEmpty(); }}
    }

    public class AndComposite extends Composite{
        public override Object evaluate(){
            for(Expression expr : children) {
                if(! (Boolean) expr.evaluate()) {
                    return false;
                }
            }

            return true;
        }
    }

    public class OrComposite extends Composite{
        public override Object evaluate(){
            for(Expression expr : children) {
                if((Boolean) expr.evaluate()) {
                    return true;
                }
            }
            return false;
        }
    }

    public class NotComposite extends Composite {
        public override Object evaluate(){
            return ! (Boolean) children[0].evaluate();
        }
    }

    public class GreaterThanComposite extends Composite {
        public override Object evaluate(){
            Double val1 = (Double) children[0].evaluate();
            Double val2 = (Double) children[1].evaluate();
            return val1 > val2;
        }
    }

    public class LessThanComposite extends Composite {
        public override Object evaluate(){
            Double val1 = (Double) children[0].evaluate();
            Double val2 = (Double) children[1].evaluate();
            return val1 < val2;
        }
    }

    public class EqualsComposite extends Composite {
        public override Object evaluate(){
            Double val1 = (Double) children[0].evaluate();
            Double val2 = (Double) children[1].evaluate();
            return val1 == val2;
        }
    }

    public class NotEqualsComposite extends Composite {
        public override Object evaluate(){
            Double val1 = (Double) children[0].evaluate();
            Double val2 = (Double) children[1].evaluate();
            return val1 != val2;
        }
    }

    public class Variable implements Expression{
        public String  name  {get;private set;}
        public Object value {get;private set;}

        public Variable(String name){ this.name = name; }

        public Expression add(Expression expr){ return this; }

        public Expression set(String name, Object value){
            if(this.name != null && this.name.equalsIgnoreCase(name)) {
                this.value = value;
            }
            return this;
        }
        public Object evaluate(){ return value; }
    }
}
