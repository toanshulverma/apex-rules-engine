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

public with sharing class DateHelper {
    public static Date parseDate(String val){
        Date retVal;
        if(String.isNotBlank(val)){
            try{
                retVal = Date.parse(val);
            }
            catch(Exception e){
                try{
                    retVal = Date.valueof(val);
                }
                catch(Exception ex){
                    DATETIME dateTimeVal = DATETIME.parse(val);
                    retval = dateTimeVal.date();
                }
            }
        }
        return retVal;
    }

    public static Datetime parseDateTime(String val){
        Datetime retVal;
        if(String.isNotBlank(val)){
            try{
                retVal = DATETIME.valueOf(val);
            }
            catch(Exception ex){
                Date dt = parseDate(val);
                retVal = Datetime.newInstanceGmt(dt, Time.newInstance(21, 33, 36, 00));
            }
        }
        return retVal;
    }
}