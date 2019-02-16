
/* description: Parses and executes mathematical expressions. */

/* lexical grammar */
%lex
%%


\n+                                return 'NL'
\s+                                /* skip whitespace */
[#]+                               return 'HEADING'
[\w ]+                             return 'CONTENT'
<<EOF>>                            return 'EOF'

/lex


%start expressions

%% /* language grammar */

expressions
: e EOF
    {
        console.log($1)
        return $1;
    };


e
    : line NL e
    {
        $$ = `${$1}</br>${$3}`
    } 
    | line NL

    {
        $$ = `${$1}</br>`
    }   
    | line
    {
       $$ = $1
    };

line : CONTENT
    {
        $$ = $1
    }
    | HEADING CONTENT
    {
        if($1.length > 6){
            $$ = `${$1}${$2}`
            return;
        }
        $$ = `<h${$1.length}>${$2}</h${$1.length}>`
    };
