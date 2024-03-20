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

public class DatetimeComparator implements DataTypeComparator{
    Datetime val1, val2;
    public DatetimeComparator(Object val1, Object val2){

        if(val1 instanceof Datetime){
            this.val1 = (Datetime) val1;
            this.val2 = (Datetime) val2;
        } 
        else{
            this.val1 = DateHelper.parseDate( (String) val1);
            this.val2 = DateHelper.parseDate( (String) val2);
        }
    }
    public Object greaterThan(){
        return val1 > val2;
    }
    public Object greaterThanOrEqual(){
        return val1 >= val2;
    }
    public Object lessThan(){
        return val1 < val2;
    }
    public Object lessThanOrEqual(){
        return val1 <= val2;
    }
    public Object equalTo(){
        return val1 == val2;
    }
    public Object notEqualTo(){
        return val1 != val2;
    }
}