package sql;

// Do not edit this file! Generated by Ragel.
// ragel -G2 -J -o P.java P.rl

import java.util.ArrayList;
import java.util.List;

/**
 * 编译，并根据我们的自定义修改SQL
 */
class P {


    static class Condition {
        /**
         * 保持
         */
        String text;
    }

    static boolean debug = true;


    public static List<Pair> p(String sql){
        List<Pair>  pairs = new ArrayList<>();
        String namedParams = "";
        String quote = "";

        char[] data = sql.toCharArray();
        int cs, p = 0 , pe = sql.length(), eof = pe;
        int pairStart = 0;
        int pairEnd = 0;
        int namedStart = 0;

        %%{
        machine sqlp;

        action buffer {
            namedStart = p;
        }

        action namedQueryStringFull {
            pairEnd = p;
        }

        action namedQueryStringGetter{
            if(debug){ System.out.println("--Wow:"+new String(data,namedStart,p-namedStart)); }
        }


        action pairBlockBegin{
            pairStart = p;
        }
        action pairBlockEnd{
            namedParams = new String(data,namedStart,pairEnd-namedStart);
            quote = new String(data,pairStart,p-pairStart) ;
            Pair pair = new Pair();
            pair.quote = quote;
            pair.namedParams = namedParams;
            pairs.add(pair);

            if(debug){ System.out.println(quote); }

            namedParams = null;
            quote = null;

        }

        pairStart = '#{';
        pairEnd = '}';
        namedQueryStringFull = ( ':'alnum+)
                    >buffer
                    %namedQueryStringFull
                    ;

        pairBlock =
                (pairStart
                    any*
                    namedQueryStringFull
                    any*
                    pairEnd)
                >pairBlockBegin %pairBlockEnd
                ;

        main := any* pairBlock any*;

        write init;
        write exec;

        }%%

        return pairs;
    }

    %% write data;

}
