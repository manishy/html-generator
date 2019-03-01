
/* description: Parses and executes mathematical expressions. */

/* lexical grammar */
%lex
%%


\n+                                return 'NL'
\s+                                /* skip whitespace */
[#]+                               return 'HEADING'
[\w ]+                             return 'CONTENT'
<<EOF>>                            return 'EOF'
(\*\*)|(\_\_)                      return 'BOLD'


/lex


%start expressions

%% /* language grammar */

expressions
: e EOF
    {
        console.log(JSON.stringify($1, null,1))
        // console.log($1)
        return $1;
    };


e
    : line NL e
    {
        // $$ = [$1, 'NL', $3]
        $$ = `${$1}</br>${$3}`
    } 
    | line NL
    {
        // $$ = [$1, 'NL']
        $$ = `${$1}</br>`
    }   
    | line
    {
        // $$ = [$1]
       $$ = $1
    };

line : CONTENT
    {
        $$ = [
            [{
            'type':'CONTENT',
            'value' : $1
            }]
        ]
    }
    | HEADING CONTENT
    {
        if($1.length > 6){
            $$ = [
                [{
                'type': 'CONTENT',
                'value': `${$1}${$2}`
                }]
            ]
            return;
        }
        $$ = [
            [{'type': 'HEADING','value': `h${$1.length}`}],
            [{'type': 'CONTENT','value': $2}]
             ]
    }
    | 
    ////////////  ///////////// add bold content , can move content to different definition
    ;

boldcontent : BOLD CONTENT BOLD
    {
        $$ = [
            [{'type': 'BOLD','value': $2}]
             ]
    }
