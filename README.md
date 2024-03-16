# Apex Rules Engine

Engine to parse an expression with logical and comparion operators (.e.g `1 && 2 && (3 || 4)`), set the values of each token in the statement, and evaluate to a boolean.

## Usage

Pass a string to the logical parser, set the values of the tokens in the expression, and then set the expression.
Value of tokens can be set as :
- **Double**, for example *123.23*
- **Integer** - for example *34*
- **Boolean** - for example, *True* or *False*
- **String** - for example, *Approved*

## Logical Operators Supported
|Operator|Usage|
|--|--|
|&&| AND|
|\|\|| OR|
|!| NOT|

## Comparison Operators Supported
|Operator|Usage|
|--|--|
|>|Greater than|
|<|Less than|
|=|Equal to|
|!=|Not Equal to|
|>=|Greater than or equal to|
|<=|Less than or equal to|


**Evaluate '1 && 2'**
```
LogicParser.Expression exp = 
    new LogicParser().parseLogicalExpression('1 && 2');

exp.set('1', true)
exp.set('2', true);
System.assertEquals(true, exp.evaluate());

exp.set('1', true)
exp.set('2', false);
System.assertEquals(false, exp.evaluate());
```

**Evaluate '( 1 && 2 ) || ( 3 && 4 )'**
```
LogicParser.Expression exp = 
    new LogicParser().parseLogicalExpression('( 1 && 2 ) || ( 3 && 4 )');

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
```

**Evaluate !( 1 && 2 )**
```
LogicParser.Expression exp =  new LogicParser().parseLogicalExpression('!( 1 && 2 )');

exp.set('1', false);
exp.set('2', false);
System.assertEquals(true, exp.evaluate());

exp.set('1', true);
exp.set('2', true);
System.assertEquals(false, exp.evaluate());
```

**Evaluate (0 != 2) && ( 3 < 4 )**
```
LogicalOperationHelper.Expression exp = new LogicalOperationHelper().parseLogicalExpression('(0 != 2) && ( 3 < 4 )');

exp.set('0', 5000);
exp.set('2', 5000);
exp.set('3', 4000);
exp.set('4', 6000);
System.assertEquals(false, exp.evaluate());
```


**Evaluate (1 >= 2) || (3 <= 4)**
```
LogicParser.Expression exp = new LogicParser().parseLogicalExpression('(1 >= 2) || (3 <= 4)');
exp.set('1', 6000);
exp.set('2', 6000);
exp.set('3', 3000);
exp.set('4', 4000);

System.assertEquals(true, exp.evaluate());
```

**Evaluate (1 = 2) || (3 != 4)**
```
LogicParser.Expression exp = new LogicParser().parseLogicalExpression('(1 = 2) || (3 != 4)');
exp.set('1', 6000);
exp.set('2', 6000);
exp.set('3', 3000);
exp.set('4', 4000);

System.assertEquals(true, exp.evaluate());
```

**Evaluate for String values (1 = 2) || (3 != 4)**
```
LogicParser.Expression exp = new LogicParser().parseLogicalExpression('(1 = 2) || (3 != 4)');
exp.set('1', 'A');
exp.set('2', 'B');
exp.set('3', 'C');
exp.set('4', 'D');

System.assertEquals(true, exp.evaluate());
```

