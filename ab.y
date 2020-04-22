    %{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <ctype.h>

    FILE *yyin;
    FILE *yyout;
    int lineno;
    int Tno=0;
    int Cno=-1;
    int t_eq;
    char astemp[20000];
    // int tstack[1000];
    // int tstacktop=0;

    char *t_identifier_name;
    char* rc0;
    char* rc1;
    char* rc2;
    char *temp;
    int vld = 0;
    extern char* yytext();
    char* copp[]={"<",">","<=",">=","==","!=","==","!=","AND","OR","XOR"};

    extern int yylex();
    void yyerror();
    int tt = 1;
    int tt2 = 1;
    int nnn = 1;
    char *current_i;
    char stk[1000][1000];
    int tops=-1;
    int yydebug=1;
    int isConditional=0;

    int update = 0;
    int valid = 0;
    int nor = 1;
    int c_op = 0;
    int ep_op = 0;
    int e_op = 0;
    int quadnum = 0;
    int p_ast = 0;
    int e_ast = 0;
    int ini_1 = 0;
    int ini_2 = 0;
    int v_for, v_while, v_if, v_else_if, v_else, v_echo, v_print;
    int v_temp = 0;//use_check
    int v_label = 0;

    #define INT_EGER 0
    #define FLOAT_NUM 1
    #define STR_ING 2
    #define NULL_TYPE 3
    #define SIZE 211
    #define MAXTOKENLEN 40
    #define MAX_VAL_LEN 100
    #define UNDEF 0

    typedef struct L_PP
    {
        int label_number;
        struct L_PP *prev;
        struct L_PP *next;
    } v_label_node;

    v_label_node *v_l;
    v_label_node *v_l2;
    v_label_node *v_l3;
    v_label_node *v_l4;

    typedef struct icref{
        char index[1000];
        char ic[10000];
        struct icref* next;
    } icref;

    struct quadruple
    {
        int line;
        char *op;
        char *arg1;
        char *arg2;
        char *result;
    } tuple[1000];

    typedef struct RefList
    {
        int lineno;
        struct RefList *next;
        int type;
    } RefList;

    typedef struct list_t
    {
        char st_name[MAXTOKENLEN];
        int st_size;
        int scope;
        RefList *lines;
        int st_type;
        char *data_type;
        char *data_value;
        struct list_t *next;
    } list_t;

    typedef struct AST
    {
        char *name;
        struct AST *parent;
        struct AST *left;
        struct AST *right;
    } node;

    typedef struct L_P
    {
        struct AST *addr;
        struct L_P *prev;
        struct L_P *next;
    } node_p;


    /*typedef struct snode_t
    {
        char *value;
    } snode_t;*/
    typedef struct snode
    {
        char* t_nodes[1000];
        int nf;
        int ln;
        struct snode *next;
    } snode;

    extern int nic;
    extern int pnic;
    extern int no_of_sn = 1;
    snode *list_root;
    snode *l_root;

    snode* new_sn();

    typedef struct icg_quadruples{
            char *op;
            char *arg1;
            char *arg2;
            char *res;
    } icg;

    int icg_count = 0;
    icg q[250];
    char *icode;
    char *icode_prev;
    char *icode_temp;
    int no_of_temp = 0;
    int no_of_labels = 0;



    char* we;
    node* expr_p;
    int icg_a=0;
    int icg_at=1;
    node_p* poi;
    node_p* e_poi;
    extern int ln_num;
    node* root;
    node* head;
    int temporaryGenerated = 0;
    int tupleIndex = 0;
    node *e,*e1,*e2,*e3,*e4,*e5,*e6,*e7,*e8,*e9,*e10;
    extern void s_current_lookup(char *idi);
    char *r_current_lookup();
    static list_t **hash_table;
    void init_hash_table();
    unsigned int hash(char *key);
    void bn(char *op);
    extern void insert(char *name, int len, int type, int lineno, int c_scope);
    list_t *lookup(char *name);
    node* buildTree(char *op, char *left, char *right, node* new1);
    void printTree(node *tree);
    void display_icg();
    void newICG(int index);
    void codeGenerator(char*,char*,char*,char*);
    char* newTemp();
    extern void symtab_dump(FILE * of, int dp);
    extern void e_vld(int vld);
    %}

    %token T_S_COMMENT T_M_COMMENT T_WHITESPACE T_OPEN_TAG T_CLOSE_TAG T_DOLLAR T_UNDERSCORE T_SEMI_COLON T_O_NBRAC T_C_NBRAC T_O_CBRAC T_C_CBRAC T_CONCAT T_DOUBLE_QUOTE T_SINGLE_QUOTE T_COMMA T_AND_EQUAL T_IS_EQUAL T_IDENTICAL T_NOT_EQUAL T_NOT_IDENTICAL T_LESSER_THAN T_GREATER_THAN T_LESSER_EQUAL T_GREATER_EQUAL T_LOGICAL_AND T_AND_OP T_LOGICAL_OR T_OR_OP T_LOGICAL_XOR T_NOT T_FOR T_WHILE T_IF T_ELSE T_ELSEIF T_ECHO T_PRINT T_INCREMENT T_DECREMENT T_PLUS T_MINUS T_DIVIDE T_MULTIPLY T_NULL T_LETTERS T_CR T_NEW_LINE T_ANY_CHAR 
    %union {
        int integer;
        float decimal;
        char op;
        int cop;
        char *string;
        struct
        {   int type;
            char tno; 
            int integer;
            float decimal;
            char *string;
        } mul;
    } 

    %token<string> T_IDENTIFIER 
    %token<string> T_STR 
    %token<integer> T_INTEGER 
    %token<decimal> T_FLOAT 
    %token<integer> T_BOOL_T 
    %token<integer> T_BOOL_F 
    %type<integer> BOOLEAN 
    %type<mul> CONST 
    %type<mul> DIG 
    %type<mul> EE 
    %type<mul> EXPR
    %type<mul> EXPR1 
    %type<mul> EXPR2
    %type<mul> COND
    %type<mul> COND1
    %type<mul> PRINT_ECHO 
    %type<mul> PE 
    %type<op> OPER 
    %type<op> AA_OPER 
    %type<op> A_OPER 
    %type<mul> ASIGN 
    %type<op> OPERDIV 
    %type<op> OPERMUL
    %type<cop> CC_OPER
    %type<cop> C_OPER 
    %type<cop> CC_OPER1
    %type<cop> C_OPER1
    %%

    start:T_OPEN_TAG {
        root = buildTree("PHP_CODE_O","CODE","ER_P_C", NULL);
        head=root;head = root->left;ini_1=1;
    } 
    CODE {
        head=root;
    } 
    end {
        buildTree("","","PHP_CODE_C", root);
    }
    |error {
        e_ast = 1;
        if(ini_1==0){
            root = buildTree("ER_P_O","CODE","ER_P_C", NULL);
            head=root;head = root->left;
            ini_1=1;
        };
    } 
    CODE {    
        if(ini_2==1)
        {
            head=root;
        };
        e_ast = 1;
    } 
    end {
        root = buildTree("","","PHP_CODE_C", root);
        e_ast = 1;
    };




    DELM:T_CONCAT { 
        e_vld(0); 
    }
    |T_COMMA { 
        e_vld(0); 
    };
    PE:DELM PRINT_ECHO { 
        $$ = $2; 
    };
    PRINT_ECHO:EXPR PE
    {
        int sss = 0;
        char s[1000];
        if ($1.type == INT_EGER)
        {
            sprintf(s, "%d", $1.integer);
            sss = 1;
        }
        if ($1.type == STR_ING)
        {
            sprintf(s, "%s", $1.string);
            sss = 1;
        }
        if ($1.type == FLOAT_NUM)
        {
            sprintf(s, "%f", $1.decimal);
            sss = 1;
        }
        char a[1000];
        int aaa = 0;
        if ($2.type == INT_EGER)
        {
            sprintf(a, "%d", $2.integer);
            aaa = 1;
        }
        if ($2.type == STR_ING)
        {
            sprintf(a, "%s", $2.string);
            aaa = 1;
        }
        if ($2.type == FLOAT_NUM)
        {
            sprintf(a, "%f", $2.decimal);
            aaa = 1;
        }
        if(aaa==1 && sss==1)
        {
            strcat(s, a);
        }
        else if(aaa==0 && sss==1)
        {
            ;//pass
        }
        else if(aaa==1 && sss==0)
        {
            strcat(s, a);
        }
        else if(aaa==0 && sss==0)
        {
            sprintf(s, "%s", "");
        }
        $$.type = STR_ING;
        $$.string = s;
        if(ep_op == 1)
        {
            char *ss = (char*)malloc(sizeof(char)*100);
            sprintf(ss, "%s", s);
            buildTree("",ss,"",head->left);
            //printf(" -[%s]- \n", head->left->name);
            head = head->parent;
            c_op = 0;
        }
        ep_op = 0;
    }
    |EXPR { $$ = $1; };

    PRINT:T_PRINT T_O_NBRAC PRINT_ECHO T_C_NBRAC T_SEMI_COLON;
    ECHO:T_ECHO PRINT_ECHO {
        if ($2.type == INT_EGER)
            printf("%d\n", $2.integer);
        if ($2.type == STR_ING)
            printf("%s\n", $2.string);
        if ($2.type == FLOAT_NUM)
            printf("%f\n", $2.decimal);
    } T_SEMI_COLON;

    BOOLEAN:T_BOOL_T
    {
        $$ = 1;
    }
    |T_BOOL_F
    {
        $$ = 0;
    };

    DIG:T_FLOAT
    {
        $$.type = FLOAT_NUM;
        $$.decimal = $1;
        char *ss = (char*)malloc(sizeof(char)*100);
        if(c_op == 1)
        {
            sprintf(ss, "%f", $1);
            head = buildTree("",ss,"CODE_C",head);
            head = head->right;
            c_op = 0;
        }
    }
    |T_INTEGER
    {
        $$.type = INT_EGER;
        $$.integer = $1;
        if(c_op == 1)
        {
            char *ss = (char*)malloc(sizeof(char)*100);
            sprintf(ss, "%d", $1);
            //exit(0);

            head = buildTree("",ss,"CODE_C",head);
            head = head->right;

            //buildTree("",ss,"CODE_C",head->left->right);
            //head = head->parent;
            //printf(" -[%s]- \n", head->name);
            c_op = 0;
        }
    }|
    T_MINUS T_FLOAT
    {
        $$.type = FLOAT_NUM;
        $$.decimal = -$2;
        char *ss = (char*)malloc(sizeof(char)*100);
        if(c_op == 1)
        {
            sprintf(ss, "%f", -$2);
            head = buildTree("",ss,"CODE_C",head);
            head = head->right;
            c_op = 0;
        }
    }
    |
    T_MINUS T_INTEGER
    {
        $$.type = INT_EGER;
        $$.integer = -$2;
        if(c_op == 1)
        {
            char *ss = (char*)malloc(sizeof(char)*100);
            sprintf(ss, "%d", -$2);
            //exit(0);

            head = buildTree("",ss,"CODE_C",head);
            head = head->right;

            //buildTree("",ss,"CODE_C",head->left->right);
            //head = head->parent;
            //printf(" -[%s]- \n", head->name);
            c_op = 0;
        }
    };

    CONST:DIG { 
        c_op = 0;
        $$ = $1; 
    }
    |T_STR
    {
        $$.type = STR_ING;
        $$.string = $1;
        char *ss = (char*)malloc(sizeof(char)*100);
        if(c_op == 1)
        {
            sprintf(ss, "%s", $1);
            head = buildTree("",ss,"CODE_C",head);
            head = head->right;
            c_op = 0;
        }
        if(ep_op == 1)
        {
            sprintf(ss, "%s", $1);
            buildTree("",ss,"",head);
            //printf(" -[%s]- \n", head->left->name);
            //head = head->parent;
            ep_op = 0;
        }
    }
    |BOOLEAN
    {
        $$.type = INT_EGER;
        $$.integer = $1;
    }
    |T_NULL
    {
        $$.type = NULL_TYPE;
    };

    IN_DE:T_INCREMENT { e_vld(0); }
    |T_DECREMENT { e_vld(0); };
    OPERDIV:T_DIVIDE { 
        //e_op = 1;
        //head = buildTree("","/","",head);
        $$ = '/'; 
        icg_at = 1;
    }

    OPERMUL:T_MULTIPLY { 
        //e_op = 1;
        //head = buildTree("","*","",head);
        $$ = '*'; 
        icg_at = 1;
    }

    OPER:T_PLUS {  
        //e_op = 1;
        //head = buildTree("","+","",head);
        $$ = '+'; 
        icg_at = 1;
    }
    |T_MINUS {  
        //e_op = 1;
        //head = buildTree("","-","",head);
        $$ = '-'; 
        icg_at = 1;
    }
    |T_OR_OP {  
        //e_op = 1;
        //head = buildTree("","||","",head);
        //c_op = 1;
        //head = buildTree("","CODE_C","",head);
        //head=head->left;
        //head = buildTree("","||","CODE_C",head);
        $$ = '|'; 
        icg_at = 1;
    }
    |T_AND_OP {  
        //e_op = 1;
        //exit(0);
        //head = buildTree("","&&","",head);
        //c_op = 1;
        //head = buildTree("","&&","CODE_C",head);
        //head=head->right;
        $$ = '&'; 
        icg_at = 1;
    };

    AA_OPER:T_MULTIPLY T_AND_EQUAL { $$ = 'M'; }
    |T_DIVIDE T_AND_EQUAL { $$ = 'D'; }
    |T_PLUS T_AND_EQUAL { $$ = 'P'; }
    |T_MINUS T_AND_EQUAL { $$ = 'S'; }
    |T_CONCAT T_AND_EQUAL { $$ = 'C'; }
    |T_AND_EQUAL { 
        $$ = '='; 
        icg_a = 1;
    };

    A_OPER:AA_OPER
    {
        e_vld(1);
        $$ = $1;
    };

    CC_OPER1:T_LESSER_THAN {$$=0;
        c_op = 1;
        //printf(" -[%s]- \n", head->name);
        head = buildTree("",rc0,"CODE_C",head);
        head=head->right;
        head = buildTree("","<","CODE_C",head);
        head=head->right;
    }
    |T_GREATER_THAN {$$=1;
        c_op = 1;
        //head = buildTree("","CODE_C","",head);
        //head=head->left;
        head = buildTree("",rc0,"CODE_C",head);
        head=head->right;
        head = buildTree("","<","CODE_C",head);
        head=head->right;
    }
    |T_LESSER_EQUAL {$$=2;
        c_op = 1;
        //head = buildTree("","CODE_C","",head);
        //head=head->left;
        head = buildTree("",rc0,"CODE_C",head);
        head=head->right;
        head = buildTree("","<=","CODE_C",head);
        head=head->right;
    }
    |T_GREATER_EQUAL {$$=3;
        c_op = 1;
        //head = buildTree("","CODE_C","",head);
        //head=head->left;
        head = buildTree("",rc0,"CODE_C",head);
        head=head->right;
        head = buildTree("",">=","CODE_C",head);
        head=head->right;
    } 
    |T_IS_EQUAL {$$=4;
        c_op = 1;
        //head = buildTree("","CODE_C","",head);
        //head=head->left;
        head = buildTree("",rc0,"CODE_C",head);
        head=head->right;
        head = buildTree("","==","CODE_C",head);
        head=head->right;
    }
    |T_NOT_EQUAL {$$=5;
        c_op = 1;
        //head = buildTree("","CODE_C","",head);
        //head=head->left;
        head = buildTree("",rc0,"CODE_C",head);
        head=head->right;
        head = buildTree("","!=","CODE_C",head);
        head=head->right;
    }
    |T_IDENTICAL {$$=6;
        c_op = 1;
        //head = buildTree("","CODE_C","",head);
        //head=head->left;
        head = buildTree("",rc0,"CODE_C",head);
        head=head->right;
        head = buildTree("","===","CODE_C",head);
        head=head->right;
    }
    |T_NOT_IDENTICAL { $$=7;
        c_op = 1;
        //head = buildTree("","CODE_C","",head);
        //head=head->left;
        head = buildTree("",rc0,"CODE_C",head);
        head=head->right;
        head = buildTree("","!==","CODE_C",head);
        head=head->right;

    }

CC_OPER:T_LOGICAL_AND { $$=8;
        head = buildTree("","AND","CODE_C",head);
        head=head->right;
    }
    |T_LOGICAL_OR {  $$=9;
        head = buildTree("","OR","CODE_C",head);
        head=head->right;
    }
    |T_LOGICAL_XOR {  $$=10;
        head = buildTree("","XOR","CODE_C",head);
        head=head->right;
    };
C_OPER1:CC_OPER1{ e_vld(0);$$=$1; };
C_OPER:CC_OPER { e_vld(0);$$=$1; };

    ET:T_IDENTIFIER IN_DE|IN_DE T_IDENTIFIER;

    EE:CONST { $$ = $1; int tno1=-1,tno2=-1;
    if($1.tno==-1){
    if($1.type==INT_EGER){
    // sprintf(astemp," %s\nT%d = %d ",astemp,++Tno,$1.integer);
        if(tt == 1 || tt2 == 1)
{
    sprintf(astemp,"%s\nT%d = %d",astemp,++Tno,$1.integer);
}
    // Tno++;
    }
    else if($1.type==STR_ING){
    // sprintf(astemp," %s\nT%d = %d ",astemp,++Tno,$1.string);
            if(tt == 1 || tt2 == 1)
{
    sprintf(astemp,"%s\nT%d = %s",astemp,++Tno,$1.string);
}
    // Tno++;
    }
    else if($1.type==FLOAT_NUM){

    // sprintf(astemp," %s\nT%d = %d ",astemp,++Tno,$1.integer);
            if(tt == 1 || tt2 == 1)
{
    sprintf(astemp,"%s\nT%d = %f",astemp,++Tno,$1.decimal);
}
    // Tno++;
    }tno1=Tno;}
    else{
        tno1=$1.tno;
    }
    //printf("%d\n",$3.tno);

    $$.tno=Tno; }
    |T_IDENTIFIER
    {
        //buildTree("","-","-",head);
        //printf(" [%s] \n",t_identifier_name);
        //buildTree("",t_identifier_name,"",head->left);
        //head = head->parent;

        list_t *c = lookup($1);
        if (c->data_value != NULL)
        {
            if (c->data_type == "Integer")
            {
                $$.type = INT_EGER;
                $$.integer = atoi(c->data_value);
            }
            if (c->data_type == "String")
            {
                $$.type = STR_ING;
                $$.string = c->data_value;
            }
            if (c->data_type == "Float")
            {
                $$.type = FLOAT_NUM;
                $$.decimal = atof(c->data_value);
            }
        }
        else
        {
            printf("Error: %s called before initialization\n", $1);
            tt = 0;
        }

        int tno1=-1,tno2=-1;
    if($$.tno==-1){
                if(tt == 1 || tt2 == 1)
{
    sprintf(astemp,"%s\nT%d = %s",astemp,++Tno,$1);
}
    tno1=Tno;}
    else{
        tno1=$$.tno;
    }
    //printf("%d\n",$3.tno);

    $$.tno=Tno;
    };
    EXPR2:EE OPERDIV EXPR2 {
    //printf("EXPR2\n");
    // we=newTemp(); 

        //codeGenerator($1,$2,$3,we);

        //expr_p = (node*)malloc(sizeof(node));
        //expr_p->name = (char*)malloc(sizeof(char)*100);
        //expr_p = buildTree("","","", expr_p);
        //expr_p->name = "";
        //printf(" -[%s]- ", head->name);
        char r1[100]; 
        char r2[100]; 
        int inva = 0;
        if ($1.type == STR_ING||$3.type == STR_ING)
        {
            printf("Error: Non-Numeric value encountered\n");
            tt = 0;
        }
        // printf("beforee: %s",astemp);
    // printf("%s\n %c ",astemp,$2);
        // printf("%d %d \n",$1.type,$3.type);
    // printf("%c\n",$1.tno);
    int tno1=-1,tno2=-1;
    if($1.tno==-1){
    if($1.type==INT_EGER){
    // sprintf(astemp," %s\nT%d = %d ",astemp,++Tno,$1.integer);
            if(tt == 1 || tt2 == 1)
{
    sprintf(astemp,"%s\nT%d = %d",astemp,++Tno,$1.integer);
}
    // Tno++;
    }
    else if($1.type==STR_ING){
    // sprintf(astemp," %s\nT%d = %d ",astemp,++Tno,$1.string);
            if(tt == 1 || tt2 == 1)
{
    sprintf(astemp,"%s\nT%d = %s",astemp,++Tno,$1.string);
}
    // Tno++;
    }
    else if($1.type==FLOAT_NUM){

    // sprintf(astemp," %s\nT%d = %d ",astemp,++Tno,$1.integer);
            if(tt == 1 || tt2 == 1)
{
    sprintf(astemp,"%s\nT%d = %f",astemp,++Tno,$1.decimal);
}
    // Tno++;
    }tno1=Tno;}
    else{
        tno1=$1.tno;
    }
    //printf("%d\n",$3.tno);

    if($3.tno==-1){
    if($3.type==INT_EGER){
    // sprintf(astemp," %s\nT%d = %d ",astemp,++Tno,$3.integer);
            if(tt == 1 || tt2 == 1)
{
    sprintf(astemp,"%s\nT%d = %d",astemp,++Tno,$3.integer);
}
    // Tno++;
    }
    else if($3.type==STR_ING){
    // sprintf(astemp," %s\nT%d = %d ",astemp,++Tno,$3.string);
            if(tt == 1 || tt2 == 1)
{
    sprintf(astemp,"%s\nT%d = %s",astemp,++Tno,$3.string);
}
    // Tno++;
    }
    else if($3.type==FLOAT_NUM){

    // sprintf(astemp," %s\nT%d = %d ",astemp,++Tno,$3.integer);
            if(tt == 1 || tt2 == 1)
{
    sprintf(astemp,"%s\nT%d = %f",astemp,++Tno,$3.decimal);
}

    // Tno++;
    }tno2=Tno;}
    else{
        tno2=$3.tno;
    }
            if(tt == 1 || tt2 == 1)
{
    sprintf(astemp,"%s\nT%d = T%d %c T%d",astemp,++Tno,tno1,$2,tno2); 
}
    $$.tno=Tno;
    // tstack[tstacktop++]=Tno;
        // sprintf(astemp,"%s\n  %c ",astemp,$2);
        // printf("under expr1 : %s",astemp);
        switch ($2)
        {
        case '+':
            if ($1.type == FLOAT_NUM && $3.type == FLOAT_NUM)
            {   
                $$.type = FLOAT_NUM;
                $$.decimal = $1.decimal + $3.decimal;
                break;
            }
            if ($1.type == INT_EGER && $3.type == FLOAT_NUM)
            {
                $$.type = FLOAT_NUM;
                $$.decimal = $1.integer + $3.decimal;
                break;
            }
            if ($1.type == FLOAT_NUM && $3.type == INT_EGER)
            {
                $$.type = FLOAT_NUM;
                $$.decimal = $1.decimal + $3.integer;
                break;
            }
            if ($1.type == INT_EGER && $3.type == INT_EGER)
            {
                $$.type = INT_EGER;
                $$.integer = $1.integer + $3.integer;
                break;
            }
        case '-':
            if ($1.type == FLOAT_NUM && $3.type == FLOAT_NUM)
            {
                $$.type = FLOAT_NUM;
                $$.decimal = $1.decimal - $3.decimal;
                break;
            }
            if ($1.type == INT_EGER && $3.type == FLOAT_NUM)
            {
                $$.type = FLOAT_NUM;
                $$.decimal = $1.integer - $3.decimal;
                break;
            }
            if ($1.type == FLOAT_NUM && $3.type == INT_EGER)
            {
                $$.type = FLOAT_NUM;
                $$.decimal = $1.decimal - $3.integer;
                break;
            }
            if ($1.type == INT_EGER && $3.type == INT_EGER)
            {
                $$.type = INT_EGER;
                $$.integer = $1.integer - $3.integer;
                break;
            }
        case '*':
            if ($1.type == FLOAT_NUM && $3.type == FLOAT_NUM)
            {
                $$.type = FLOAT_NUM;
                $$.decimal = $1.decimal * $3.decimal;
                break;
            }
            if ($1.type == INT_EGER && $3.type == FLOAT_NUM)
            {
                $$.type = FLOAT_NUM;
                $$.decimal = $1.integer * $3.decimal;
                break;
            }
            if ($1.type == FLOAT_NUM && $3.type == INT_EGER)
            {
                $$.type = FLOAT_NUM;
                $$.decimal = $1.decimal * $3.integer;
                break;
            }
            if ($1.type == INT_EGER && $3.type == INT_EGER)
            {
                $$.type = INT_EGER;
                $$.integer = $1.integer * $3.integer;
                break;
            }
        case '/':
            if ($1.type == FLOAT_NUM && $3.type == FLOAT_NUM)
            {
                $$.type = FLOAT_NUM;
                $$.decimal = $1.decimal / $3.decimal;
                break;
            }
            if ($1.type == INT_EGER && $3.type == FLOAT_NUM)
            {
                $$.type = FLOAT_NUM;
                $$.decimal = $1.integer / $3.decimal;
                break;
            }
            if ($1.type == FLOAT_NUM && $3.type == INT_EGER)
            {
                $$.type = FLOAT_NUM;
                $$.decimal = $1.decimal / $3.integer;
                break;
            }
            if ($1.type == INT_EGER && $3.type == INT_EGER)
            {
                if ($1.integer % $3.integer == 0)
                {
                    $$.type = INT_EGER;
                    $$.integer = $1.integer / $3.integer;
                    break;
                }
                else
                {
                    $$.type = FLOAT_NUM;
                    $$.decimal = (float)$1.integer / (float)$3.integer;
                    break;
                }
            }
        case '^':
            if ($1.type == FLOAT_NUM && $3.type == FLOAT_NUM)
            {
                $$.type = INT_EGER;
                $$.integer = (int)$1.decimal ^ (int)$3.decimal;
                break;
            }
            if ($1.type == INT_EGER && $3.type == FLOAT_NUM)
            {
                $$.type = INT_EGER;
                $$.integer = $1.integer ^ (int)$3.decimal;
                break;
            }
            if ($1.type == FLOAT_NUM && $3.type == INT_EGER)
            {
                $$.type = INT_EGER;
                $$.integer = (int)$1.decimal ^ $3.integer;
                break;
            }
            if ($1.type == INT_EGER && $3.type == INT_EGER)
            {
                $$.type = INT_EGER;
                $$.integer = $1.integer ^ $3.integer;
                break;
            }
        case '&':
            if ($1.type == FLOAT_NUM && $3.type == FLOAT_NUM)
            {
                $$.type = INT_EGER;
                $$.integer = (int)$1.decimal & (int)$3.decimal;
                break;
            }
            if ($1.type == INT_EGER && $3.type == FLOAT_NUM)
            {
                $$.type = INT_EGER;
                $$.integer = $1.integer & (int)$3.decimal;
                break;
            }
            if ($1.type == FLOAT_NUM && $3.type == INT_EGER)
            {
                $$.type = INT_EGER;
                $$.integer = (int)$1.decimal & $3.integer;
                break;
            }
            if ($1.type == INT_EGER && $3.type == INT_EGER)
            {
                $$.type = INT_EGER;
                $$.integer = $1.integer & $3.integer;
                break;
            }
        case '|':
            if ($1.type == FLOAT_NUM && $3.type == FLOAT_NUM)
            {
                $$.type = INT_EGER;
                $$.integer = (int)$1.decimal|(int)$3.decimal;
                break;
            }
            if ($1.type == INT_EGER && $3.type == FLOAT_NUM)
            {
                $$.type = INT_EGER;
                $$.integer = $1.integer|(int)$3.decimal;
                break;
            }
            if ($1.type == FLOAT_NUM && $3.type == INT_EGER)
            {
                $$.type = INT_EGER;
                $$.integer = (int)$1.decimal|$3.integer;
                break;
            }
            if ($1.type == INT_EGER && $3.type == INT_EGER)
            {
                $$.type = INT_EGER;
                $$.integer = $1.integer|$3.integer;
                break;
            }
        case 'A':
            if ($1.type == FLOAT_NUM && $3.type == FLOAT_NUM)
            {
                $$.type = INT_EGER;
                $$.integer = $1.decimal && $3.decimal;
                break;
            }
            if ($1.type == INT_EGER && $3.type == FLOAT_NUM)
            {
                $$.type = INT_EGER;
                $$.integer = $1.integer && $3.decimal;
                break;
            }
            if ($1.type == FLOAT_NUM && $3.type == INT_EGER)
            {
                $$.type = INT_EGER;
                $$.integer = $1.decimal && $3.integer;
                break;
            }
            if ($1.type == INT_EGER && $3.type == INT_EGER)
            {
                $$.type = INT_EGER;
                $$.integer = $1.integer && $3.integer;
                break;
            }
        case 'O':
            if ($1.type == FLOAT_NUM && $3.type == FLOAT_NUM)
            {
                $$.type = INT_EGER;
                $$.integer = $1.decimal||$3.decimal;
                break;
            }
            if ($1.type == INT_EGER && $3.type == FLOAT_NUM)
            {
                $$.type = INT_EGER;
                $$.integer = $1.integer||$3.decimal;
                break;
            }
            if ($1.type == FLOAT_NUM && $3.type == INT_EGER)
            {
                $$.type = INT_EGER;
                $$.integer = $1.decimal||$3.integer;
                break;
            }
            if ($1.type == INT_EGER && $3.type == INT_EGER)
            {
                $$.type = INT_EGER;
                $$.integer = $1.integer||$3.integer;
                break;
            }
        }}

    |EE {$$=$1;
    }
    EXPR1:EXPR2 OPERMUL EXPR1 {
    //printf("EXPR1\n");
    // we=newTemp(); 
        //codeGenerator($1,$2,$3,we);

        //expr_p = (node*)malloc(sizeof(node));
        //expr_p->name = (char*)malloc(sizeof(char)*100);
        //expr_p = buildTree("","","", expr_p);
        //expr_p->name = "";
        //printf(" -[%s]- ", head->name);
        char r1[100]; 
        char r2[100]; 
        int inva = 0;
        if ($1.type == STR_ING||$3.type == STR_ING)
        {
            printf("Error: Non-Numeric value encountered\n");
            tt = 0;
        }
        // printf("beforee: %s",astemp);    
    int tno1=-1,tno2=-1;
    if($1.tno==-1){
    if($1.type==INT_EGER){
    // sprintf(astemp," %s\nT%d = %d ",astemp,++Tno,$1.integer);
            if(tt == 1 || tt2 == 1)
{
    sprintf(astemp,"%s\nT%d = %d",astemp,++Tno,$1.integer);
}

    // Tno++;
    }
    else if($1.type==STR_ING){
    // sprintf(astemp," %s\nT%d = %d ",astemp,++Tno,$1.string);
            if(tt == 1 || tt2 == 1)
{
    sprintf(astemp,"%s\nT%d = %s",astemp,++Tno,$1.string);
}
    // Tno++;
    }
    else if($1.type==FLOAT_NUM){

    // sprintf(astemp," %s\nT%d = %d ",astemp,++Tno,$1.integer);
            if(tt == 1 || tt2 == 1)
{
    sprintf(astemp,"%s\nT%d = %f",astemp,++Tno,$1.decimal);
}

    // Tno++;
    }tno1=Tno;}
    else{
        tno1=$1.tno;
    }
    //printf("%d\n",$3.tno);

    if($3.tno==-1){
    if($3.type==INT_EGER){
    // sprintf(astemp," %s\nT%d = %d ",astemp,++Tno,$3.integer);
            if(tt == 1 || tt2 == 1)
{
    sprintf(astemp,"%s\nT%d = %d",astemp,++Tno,$3.integer);
}

    // Tno++;
    }
    else if($3.type==STR_ING){
    // sprintf(astemp," %s\nT%d = %d ",astemp,++Tno,$3.string);
            if(tt == 1 || tt2 == 1)
{
    sprintf(astemp,"%s\nT%d = %s",astemp,++Tno,$3.string);
}
    // Tno++;
    }
    else if($3.type==FLOAT_NUM){

    // sprintf(astemp," %s\nT%d = %d ",astemp,++Tno,$3.integer);
            if(tt == 1 || tt2 == 1)
{
    sprintf(astemp,"%s\nT%d = %f",astemp,++Tno,$3.decimal);
}

    // Tno++;
    }tno2=Tno;}
    else{
        tno2=$3.tno;
    }
            if(tt == 1 || tt2 == 1)
{
    sprintf(astemp,"%s\nT%d = T%d %c T%d",astemp,++Tno,tno1,$2,tno2); 
}
    $$.tno=Tno;
        switch ($2)
        {
        case '+':
            if ($1.type == FLOAT_NUM && $3.type == FLOAT_NUM)
            {   
                $$.type = FLOAT_NUM;
                $$.decimal = $1.decimal + $3.decimal;
                break;
            }
            if ($1.type == INT_EGER && $3.type == FLOAT_NUM)
            {
                $$.type = FLOAT_NUM;
                $$.decimal = $1.integer + $3.decimal;
                break;
            }
            if ($1.type == FLOAT_NUM && $3.type == INT_EGER)
            {
                $$.type = FLOAT_NUM;
                $$.decimal = $1.decimal + $3.integer;
                break;
            }
            if ($1.type == INT_EGER && $3.type == INT_EGER)
            {
                $$.type = INT_EGER;
                $$.integer = $1.integer + $3.integer;
                break;
            }
        case '-':
            if ($1.type == FLOAT_NUM && $3.type == FLOAT_NUM)
            {
                $$.type = FLOAT_NUM;
                $$.decimal = $1.decimal - $3.decimal;
                break;
            }
            if ($1.type == INT_EGER && $3.type == FLOAT_NUM)
            {
                $$.type = FLOAT_NUM;
                $$.decimal = $1.integer - $3.decimal;
                break;
            }
            if ($1.type == FLOAT_NUM && $3.type == INT_EGER)
            {
                $$.type = FLOAT_NUM;
                $$.decimal = $1.decimal - $3.integer;
                break;
            }
            if ($1.type == INT_EGER && $3.type == INT_EGER)
            {
                $$.type = INT_EGER;
                $$.integer = $1.integer - $3.integer;
                break;
            }
        case '*':
            if ($1.type == FLOAT_NUM && $3.type == FLOAT_NUM)
            {
                $$.type = FLOAT_NUM;
                $$.decimal = $1.decimal * $3.decimal;
                break;
            }
            if ($1.type == INT_EGER && $3.type == FLOAT_NUM)
            {
                $$.type = FLOAT_NUM;
                $$.decimal = $1.integer * $3.decimal;
                break;
            }
            if ($1.type == FLOAT_NUM && $3.type == INT_EGER)
            {
                $$.type = FLOAT_NUM;
                $$.decimal = $1.decimal * $3.integer;
                break;
            }
            if ($1.type == INT_EGER && $3.type == INT_EGER)
            {
                $$.type = INT_EGER;
                $$.integer = $1.integer * $3.integer;
                break;
            }
        case '/':
            if ($1.type == FLOAT_NUM && $3.type == FLOAT_NUM)
            {
                $$.type = FLOAT_NUM;
                $$.decimal = $1.decimal / $3.decimal;
                break;
            }
            if ($1.type == INT_EGER && $3.type == FLOAT_NUM)
            {
                $$.type = FLOAT_NUM;
                $$.decimal = $1.integer / $3.decimal;
                break;
            }
            if ($1.type == FLOAT_NUM && $3.type == INT_EGER)
            {
                $$.type = FLOAT_NUM;
                $$.decimal = $1.decimal / $3.integer;
                break;
            }
            if ($1.type == INT_EGER && $3.type == INT_EGER)
            {
                if ($1.integer % $3.integer == 0)
                {
                    $$.type = INT_EGER;
                    $$.integer = $1.integer / $3.integer;
                    break;
                }
                else
                {
                    $$.type = FLOAT_NUM;
                    $$.decimal = (float)$1.integer / (float)$3.integer;
                    break;
                }
            }
        case '^':
            if ($1.type == FLOAT_NUM && $3.type == FLOAT_NUM)
            {
                $$.type = INT_EGER;
                $$.integer = (int)$1.decimal ^ (int)$3.decimal;
                break;
            }
            if ($1.type == INT_EGER && $3.type == FLOAT_NUM)
            {
                $$.type = INT_EGER;
                $$.integer = $1.integer ^ (int)$3.decimal;
                break;
            }
            if ($1.type == FLOAT_NUM && $3.type == INT_EGER)
            {
                $$.type = INT_EGER;
                $$.integer = (int)$1.decimal ^ $3.integer;
                break;
            }
            if ($1.type == INT_EGER && $3.type == INT_EGER)
            {
                $$.type = INT_EGER;
                $$.integer = $1.integer ^ $3.integer;
                break;
            }
        case '&':
            if ($1.type == FLOAT_NUM && $3.type == FLOAT_NUM)
            {
                $$.type = INT_EGER;
                $$.integer = (int)$1.decimal & (int)$3.decimal;
                break;
            }
            if ($1.type == INT_EGER && $3.type == FLOAT_NUM)
            {
                $$.type = INT_EGER;
                $$.integer = $1.integer & (int)$3.decimal;
                break;
            }
            if ($1.type == FLOAT_NUM && $3.type == INT_EGER)
            {
                $$.type = INT_EGER;
                $$.integer = (int)$1.decimal & $3.integer;
                break;
            }
            if ($1.type == INT_EGER && $3.type == INT_EGER)
            {
                $$.type = INT_EGER;
                $$.integer = $1.integer & $3.integer;
                break;
            }
        case '|':
            if ($1.type == FLOAT_NUM && $3.type == FLOAT_NUM)
            {
                $$.type = INT_EGER;
                $$.integer = (int)$1.decimal|(int)$3.decimal;
                break;
            }
            if ($1.type == INT_EGER && $3.type == FLOAT_NUM)
            {
                $$.type = INT_EGER;
                $$.integer = $1.integer|(int)$3.decimal;
                break;
            }
            if ($1.type == FLOAT_NUM && $3.type == INT_EGER)
            {
                $$.type = INT_EGER;
                $$.integer = (int)$1.decimal|$3.integer;
                break;
            }
            if ($1.type == INT_EGER && $3.type == INT_EGER)
            {
                $$.type = INT_EGER;
                $$.integer = $1.integer|$3.integer;
                break;
            }
        case 'A':
            if ($1.type == FLOAT_NUM && $3.type == FLOAT_NUM)
            {
                $$.type = INT_EGER;
                $$.integer = $1.decimal && $3.decimal;
                break;
            }
            if ($1.type == INT_EGER && $3.type == FLOAT_NUM)
            {
                $$.type = INT_EGER;
                $$.integer = $1.integer && $3.decimal;
                break;
            }
            if ($1.type == FLOAT_NUM && $3.type == INT_EGER)
            {
                $$.type = INT_EGER;
                $$.integer = $1.decimal && $3.integer;
                break;
            }
            if ($1.type == INT_EGER && $3.type == INT_EGER)
            {
                $$.type = INT_EGER;
                $$.integer = $1.integer && $3.integer;
                break;
            }
        case 'O':
            if ($1.type == FLOAT_NUM && $3.type == FLOAT_NUM)
            {
                $$.type = INT_EGER;
                $$.integer = $1.decimal||$3.decimal;
                break;
            }
            if ($1.type == INT_EGER && $3.type == FLOAT_NUM)
            {
                $$.type = INT_EGER;
                $$.integer = $1.integer||$3.decimal;
                break;
            }
            if ($1.type == FLOAT_NUM && $3.type == INT_EGER)
            {
                $$.type = INT_EGER;
                $$.integer = $1.decimal||$3.integer;
                break;
            }
            if ($1.type == INT_EGER && $3.type == INT_EGER)
            {
                $$.type = INT_EGER;
                $$.integer = $1.integer||$3.integer;
                break;
            }
        }}

    |EXPR2 {$$=$1;
    // Tv=0;
    //printf("EXPR1-EXPR2\n");
    }

    EXPR:EXPR1 OPER EXPR
    {  //printf("EXPR\n");
        // we=newTemp(); 
        //codeGenerator($1,$2,$3,we);
        // sprintf(astemp,"%s %c ",astemp,$2);
        //expr_p = (node*)malloc(sizeof(node));
        //expr_p->name = (char*)malloc(sizeof(char)*100);
        //expr_p = buildTree("","","", expr_p);
        //expr_p->name = "";
        //printf(" -[%s]- ", head->name);
        char r1[100]; 
        char r2[100]; 
        int inva = 0;
        if ($1.type == STR_ING||$3.type == STR_ING)
        {
            printf("Error: Non-Numeric value encountered\n");
            tt = 0;
        }
    int tno1=-1,tno2=-1;
    if($1.tno==-1){
    if($1.type==INT_EGER){
    // sprintf(astemp," %s\nT%d = %d ",astemp,++Tno,$1.integer);
            if(tt == 1 || tt2 == 1)
{
    sprintf(astemp,"%s\nT%d = %d",astemp,++Tno,$1.integer);
}
    // Tno++;
    }
    else if($1.type==STR_ING){
    // sprintf(astemp," %s\nT%d = %d ",astemp,++Tno,$1.string);
            if(tt == 1 || tt2 == 1)
{
    sprintf(astemp,"%s\nT%d = %s",astemp,++Tno,$1.string);
}
    // Tno++;
    }
    else if($1.type==FLOAT_NUM){

    // sprintf(astemp," %s\nT%d = %d ",astemp,++Tno,$1.integer);
            if(tt == 1 || tt2 == 1)
{
    sprintf(astemp,"%s\nT%d = %f",astemp,++Tno,$1.decimal);
}
    // Tno++;
    }tno1=Tno;}
    else{
        tno1=$1.tno;
    }
    //printf("%d\n",$3.tno);

    if($3.tno==-1){
    if($3.type==INT_EGER){
    // sprintf(astemp," %s\nT%d = %d ",astemp,++Tno,$3.integer);
            if(tt == 1 || tt2 == 1)
{
    sprintf(astemp,"%s\nT%d = %d",astemp,++Tno,$3.integer);
}
    // Tno++;
    }
    else if($3.type==STR_ING){
    // sprintf(astemp," %s\nT%d = %d ",astemp,++Tno,$3.string);
            if(tt == 1 || tt2 == 1)
{
    sprintf(astemp,"%s\nT%d = %s",astemp,++Tno,$3.string);
}
    // Tno++;
    }
    else if($3.type==FLOAT_NUM){

    // sprintf(astemp," %s\nT%d = %d ",astemp,++Tno,$3.integer);
            if(tt == 1 || tt2 == 1)
{
    sprintf(astemp,"%s\nT%d = %f",astemp,++Tno,$3.decimal);
}
    // Tno++;
    }tno2=Tno;}
    else{
        tno2=$3.tno;
    }
            if(tt == 1 || tt2 == 1)
{
    sprintf(astemp,"%s\nT%d = T%d %c T%d",astemp,++Tno,tno1,$2,tno2); 
}
    $$.tno=Tno;  
    switch ($2)

        {
        case '+':
            if ($1.type == FLOAT_NUM && $3.type == FLOAT_NUM)
            {
                $$.type = FLOAT_NUM;
                $$.decimal = $1.decimal + $3.decimal;
                break;
            }
            if ($1.type == INT_EGER && $3.type == FLOAT_NUM)
            {
                $$.type = FLOAT_NUM;
                $$.decimal = $1.integer + $3.decimal;
                break;
            }
            if ($1.type == FLOAT_NUM && $3.type == INT_EGER)
            {
                $$.type = FLOAT_NUM;
                $$.decimal = $1.decimal + $3.integer;
                break;
            }
            if ($1.type == INT_EGER && $3.type == INT_EGER)
            {
                $$.type = INT_EGER;
                $$.integer = $1.integer + $3.integer;
                break;
            }
        case '-':
            if ($1.type == FLOAT_NUM && $3.type == FLOAT_NUM)
            {
                $$.type = FLOAT_NUM;
                $$.decimal = $1.decimal - $3.decimal;
                break;
            }
            if ($1.type == INT_EGER && $3.type == FLOAT_NUM)
            {
                $$.type = FLOAT_NUM;
                $$.decimal = $1.integer - $3.decimal;
                break;
            }
            if ($1.type == FLOAT_NUM && $3.type == INT_EGER)
            {
                $$.type = FLOAT_NUM;
                $$.decimal = $1.decimal - $3.integer;
                break;
            }
            if ($1.type == INT_EGER && $3.type == INT_EGER)
            {
                $$.type = INT_EGER;
                $$.integer = $1.integer - $3.integer;
                break;
            }
        case '*':
            if ($1.type == FLOAT_NUM && $3.type == FLOAT_NUM)
            {
                $$.type = FLOAT_NUM;
                $$.decimal = $1.decimal * $3.decimal;
                break;
            }
            if ($1.type == INT_EGER && $3.type == FLOAT_NUM)
            {
                $$.type = FLOAT_NUM;
                $$.decimal = $1.integer * $3.decimal;
                break;
            }
            if ($1.type == FLOAT_NUM && $3.type == INT_EGER)
            {
                $$.type = FLOAT_NUM;
                $$.decimal = $1.decimal * $3.integer;
                break;
            }
            if ($1.type == INT_EGER && $3.type == INT_EGER)
            {
                $$.type = INT_EGER;
                $$.integer = $1.integer * $3.integer;
                break;
            }
        case '/':
            if ($1.type == FLOAT_NUM && $3.type == FLOAT_NUM)
            {
                $$.type = FLOAT_NUM;
                $$.decimal = $1.decimal / $3.decimal;
                break;
            }
            if ($1.type == INT_EGER && $3.type == FLOAT_NUM)
            {
                $$.type = FLOAT_NUM;
                $$.decimal = $1.integer / $3.decimal;
                break;
            }
            if ($1.type == FLOAT_NUM && $3.type == INT_EGER)
            {
                $$.type = FLOAT_NUM;
                $$.decimal = $1.decimal / $3.integer;
                break;
            }
            if ($1.type == INT_EGER && $3.type == INT_EGER)
            {
                if ($1.integer % $3.integer == 0)
                {
                    $$.type = INT_EGER;
                    $$.integer = $1.integer / $3.integer;
                    break;
                }
                else
                {
                    $$.type = FLOAT_NUM;
                    $$.decimal = (float)$1.integer / (float)$3.integer;
                    break;
                }
            }
        case '^':
            if ($1.type == FLOAT_NUM && $3.type == FLOAT_NUM)
            {
                $$.type = INT_EGER;
                $$.integer = (int)$1.decimal ^ (int)$3.decimal;
                break;
            }
            if ($1.type == INT_EGER && $3.type == FLOAT_NUM)
            {
                $$.type = INT_EGER;
                $$.integer = $1.integer ^ (int)$3.decimal;
                break;
            }
            if ($1.type == FLOAT_NUM && $3.type == INT_EGER)
            {
                $$.type = INT_EGER;
                $$.integer = (int)$1.decimal ^ $3.integer;
                break;
            }
            if ($1.type == INT_EGER && $3.type == INT_EGER)
            {
                $$.type = INT_EGER;
                $$.integer = $1.integer ^ $3.integer;
                break;
            }
        case '&':
            if ($1.type == FLOAT_NUM && $3.type == FLOAT_NUM)
            {
                $$.type = INT_EGER;
                $$.integer = (int)$1.decimal & (int)$3.decimal;
                break;
            }
            if ($1.type == INT_EGER && $3.type == FLOAT_NUM)
            {
                $$.type = INT_EGER;
                $$.integer = $1.integer & (int)$3.decimal;
                break;
            }
            if ($1.type == FLOAT_NUM && $3.type == INT_EGER)
            {
                $$.type = INT_EGER;
                $$.integer = (int)$1.decimal & $3.integer;
                break;
            }
            if ($1.type == INT_EGER && $3.type == INT_EGER)
            {
                $$.type = INT_EGER;
                $$.integer = $1.integer & $3.integer;
                break;
            }
        case '|':
            if ($1.type == FLOAT_NUM && $3.type == FLOAT_NUM)
            {
                $$.type = INT_EGER;
                $$.integer = (int)$1.decimal|(int)$3.decimal;
                break;
            }
            if ($1.type == INT_EGER && $3.type == FLOAT_NUM)
            {
                $$.type = INT_EGER;
                $$.integer = $1.integer|(int)$3.decimal;
                break;
            }
            if ($1.type == FLOAT_NUM && $3.type == INT_EGER)
            {
                $$.type = INT_EGER;
                $$.integer = (int)$1.decimal|$3.integer;
                break;
            }
            if ($1.type == INT_EGER && $3.type == INT_EGER)
            {
                $$.type = INT_EGER;
                $$.integer = $1.integer|$3.integer;
                break;
            }
        case 'A':
            if ($1.type == FLOAT_NUM && $3.type == FLOAT_NUM)
            {
                $$.type = INT_EGER;
                $$.integer = $1.decimal && $3.decimal;
                break;
            }
            if ($1.type == INT_EGER && $3.type == FLOAT_NUM)
            {
                $$.type = INT_EGER;
                $$.integer = $1.integer && $3.decimal;
                break;
            }
            if ($1.type == FLOAT_NUM && $3.type == INT_EGER)
            {
                $$.type = INT_EGER;
                $$.integer = $1.decimal && $3.integer;
                break;
            }
            if ($1.type == INT_EGER && $3.type == INT_EGER)
            {
                $$.type = INT_EGER;
                $$.integer = $1.integer && $3.integer;
                break;
            }
        case 'O':
            if ($1.type == FLOAT_NUM && $3.type == FLOAT_NUM)
            {
                $$.type = INT_EGER;
                $$.integer = $1.decimal||$3.decimal;
                break;
            }
            if ($1.type == INT_EGER && $3.type == FLOAT_NUM)
            {
                $$.type = INT_EGER;
                $$.integer = $1.integer||$3.decimal;
                break;
            }
            if ($1.type == FLOAT_NUM && $3.type == INT_EGER)
            {
                $$.type = INT_EGER;
                $$.integer = $1.decimal||$3.integer;
                break;
            }
            if ($1.type == INT_EGER && $3.type == INT_EGER)
            {
                $$.type = INT_EGER;
                $$.integer = $1.integer||$3.integer;
                break;
            }
        }
        // printf("EXPR1 OPER EXPR \n");
    }
    |EXPR1 { $$ = $1; //printf("EXPR-EXPR1\n");
    };


    ASIGN:T_IDENTIFIER A_OPER EXPR
    { 
       
            //newICG(icg_count);
        //q[icg_count].res=t_identifier_name;
        //q[icg_count].op="=";
        //icg_count+=1;

        /*{buildTree("","","",head);head=head->left;}*/
        int a_op_s = 0;
        //char opp = "";
        int inva = 0;
        $$.type = NULL_TYPE;
        list_t *c = lookup($1);
        if (c->data_value != NULL)
        {
            if (c->data_type == "Integer")
            {
                $$.type = INT_EGER;
                $$.integer = atoi(c->data_value);
            }
            if (c->data_type == "String")
            {
                $$.type = STR_ING;
                $$.string = c->data_value;
            }
            if (c->data_type == "Float")
            {
                $$.type = FLOAT_NUM;
                $$.decimal = atof(c->data_value);
            }
        }

        if ($3.type == INT_EGER)
        {
            switch ($2)
            {
            case '=':
                    if(tt == 1 || tt2 == 1)
{
                sprintf(astemp,"%s\n%s %c T%d",astemp,$1,$2,Tno);
}
                $$.type = INT_EGER;
                $$.integer = $3.integer;
                a_op_s = 1;
                break;
            case 'M':
                    if(tt == 1 || tt2 == 1)
{
                sprintf(astemp,"%s\nT%d = %s",astemp,++Tno,$1);
                sprintf(astemp,"%s\nT%d = T%d * T%d",astemp,++Tno,Tno,Tno-1);
                sprintf(astemp,"%s\n%s = T%d",astemp,$1,Tno);
}
                if ($$.type == FLOAT_NUM && $3.type == INT_EGER)
                {
                    $$.type = FLOAT_NUM;
                    $$.decimal = $$.decimal * $3.integer;
                    a_op_s = 1;
                    break;
                }
                if ($$.type == INT_EGER && $3.type == INT_EGER)
                {
                    $$.type = INT_EGER;
                    $$.integer = $$.integer * $3.integer;
                    a_op_s = 1;
                    break;
                }
            case 'D':
                        if(tt == 1 || tt2 == 1)
{
                sprintf(astemp,"%s\nT%d = %s",astemp,++Tno,$1);
                sprintf(astemp,"%s\nT%d = T%d / T%d",astemp,++Tno,Tno,Tno-1);
                sprintf(astemp,"%s\n%s = T%d",astemp,$1,Tno);
}
                if ($$.type == FLOAT_NUM && $3.type == INT_EGER)
                {
                    $$.type = FLOAT_NUM;
                    if($3.integer == 0)
                    {
                        printf("Error: Operation Division by 0 Not Allowed\n");
                        inva = 1;
                        break;
                    }
                    $$.decimal = $$.decimal / $3.integer;
                    a_op_s = 1;
                    break;
                }
                if ($$.type == INT_EGER && $3.type == INT_EGER)
                {
                    if($3.integer == 0)
                    {
                        printf("Error: Operation Division by 0 Not Allowed\n");
                        inva = 1;
                        break;
                    }
                    if ($$.integer % $3.integer == 0)
                    {
                        $$.type = INT_EGER;
                        $$.integer = $$.integer / $3.integer;
                        a_op_s = 1;
                        break;
                    }
                    else
                    {
                        $$.type = FLOAT_NUM;
                        $$.decimal = (float)$$.integer / (float)$3.integer;
                        a_op_s = 1;
                        break;
                    }
                }
            case 'P':
                    if(tt == 1 || tt2 == 1)
{
                sprintf(astemp,"%s\nT%d = %s",astemp,++Tno,$1);
                sprintf(astemp,"%s\nT%d = T%d + T%d",astemp,++Tno,Tno,Tno-1);
                sprintf(astemp,"%s\n%s = T%d",astemp,$1,Tno);
}
                if ($$.type == FLOAT_NUM && $3.type == INT_EGER)
                {
                    $$.type = FLOAT_NUM;
                    $$.decimal = $$.decimal + $3.integer;
                    a_op_s = 1;
                    break;
                }
                if ($$.type == INT_EGER && $3.type == INT_EGER)
                {
                    $$.type = INT_EGER;
                    $$.integer = $$.integer + $3.integer;
                    a_op_s = 1;
                    break;
                }
            case 'S':
                    if(tt == 1 || tt2 == 1)
{
                sprintf(astemp,"%s\nT%d = %s",astemp,++Tno,$1);
                sprintf(astemp,"%s\nT%d = T%d - T%d",astemp,++Tno,Tno,Tno-1);
                sprintf(astemp,"%s\n%s = T%d",astemp,$1,Tno);
}
                if ($$.type == FLOAT_NUM && $3.type == INT_EGER)
                {
                    $$.type = FLOAT_NUM;
                    $$.decimal = $$.decimal - $3.integer;
                    a_op_s = 1;
                    break;
                }
                if ($$.type == INT_EGER && $3.type == INT_EGER)
                {
                    $$.type = INT_EGER;
                    $$.integer = $$.integer - $3.integer;
                    a_op_s = 1;
                    break;
                }
            case 'C':
                    if(tt == 1 || tt2 == 1)
{
                sprintf(astemp,"%s\nT%d = %s",astemp,++Tno,$1);
                sprintf(astemp,"%s\nT%d = T%d . T%d",astemp,++Tno,Tno,Tno-1);
                sprintf(astemp,"%s\n%s = T%d",astemp,$1,Tno);
}
                if ($$.type == FLOAT_NUM && $3.type == INT_EGER)
                {
                    $$.type = STR_ING;
                    sprintf($$.string, "%f%d", $$.decimal, $3.integer);
                    a_op_s = 1;
                    break;
                }
                if ($$.type == INT_EGER && $3.type == INT_EGER)
                {
                    $$.type = STR_ING;
                    sprintf($$.string, "%d%d", $$.integer, $3.integer);
                    a_op_s = 1;
                    break;
                }
                if ($$.type == STR_ING && $3.type == INT_EGER)
                {
                    $$.type = STR_ING;
                    sprintf($$.string, "%s%d", $$.string, $3.integer);
                    a_op_s = 1;
                    break;
                }
                tt = 0;
                printf("Error: Operation Not Allowed\n");
                $$.type = NULL_TYPE;
            }
        }
        
        if ($3.type == FLOAT_NUM)
        {
            switch ($2)
            {
            case '=':
                    if(tt == 1 || tt2 == 1)
{
                sprintf(astemp,"%s\n%s %c T%d",astemp,$1,$2,Tno);
}
                $$.type = FLOAT_NUM;
                $$.decimal = $3.decimal;
                a_op_s = 1;
                break;
            case 'M':
                    if(tt == 1 || tt2 == 1)
{
                sprintf(astemp,"%s\nT%d = %s",astemp,++Tno,$1);
                sprintf(astemp,"%s\nT%d = T%d * T%d",astemp,++Tno,Tno,Tno-1);
                sprintf(astemp,"%s\n%s = T%d",astemp,$1,Tno);
}
                if ($$.type == FLOAT_NUM && $3.type == FLOAT_NUM)
                {
                    $$.type = FLOAT_NUM;
                    $$.decimal = $$.decimal * $3.decimal;
                    a_op_s = 1;
                    break;
                }
                if ($$.type == INT_EGER && $3.type == FLOAT_NUM)
                {
                    $$.type = FLOAT_NUM;
                    $$.integer = $$.integer * $3.decimal;
                    a_op_s = 1;
                    break;
                }
            case 'D':
                    if(tt == 1 || tt2 == 1)
{
            sprintf(astemp,"%s\nT%d = %s",astemp,++Tno,$1);
                sprintf(astemp,"%s\nT%d = T%d / T%d",astemp,++Tno,Tno,Tno-1);
                sprintf(astemp,"%s\n%s = T%d",astemp,$1,Tno);
}
                if ($$.type == FLOAT_NUM && $3.type == FLOAT_NUM)
                {
                    $$.type = FLOAT_NUM;
                    if($3.decimal == 0)
                    {
                        printf("Error: Operation Division by 0 Not Allowed\n");
                        inva = 1;
                        break;
                    }
                    $$.decimal = $$.decimal / $3.decimal;
                    a_op_s = 1;
                    break;
                }
                if ($$.type == INT_EGER && $3.type == FLOAT_NUM)
                {
                    $$.type = FLOAT_NUM;
                    if($3.decimal == 0)
                    {
                        printf("Error: Operation Division by 0 Not Allowed\n");
                        inva = 1;
                        break;
                    }
                    $$.decimal = $$.integer / $3.decimal;
                    a_op_s = 1;
                    break;
                }
            case 'P':
                    if(tt == 1 || tt2 == 1)
{
            sprintf(astemp,"%s\nT%d = %s",astemp,++Tno,$1);
                sprintf(astemp,"%s\nT%d = T%d + T%d",astemp,++Tno,Tno,Tno-1);
                sprintf(astemp,"%s\n%s = T%d",astemp,$1,Tno);
}
                if ($$.type == FLOAT_NUM && $3.type == FLOAT_NUM)
                {
                    $$.type = FLOAT_NUM;
                    $$.decimal = $$.decimal + $3.decimal;
                    a_op_s = 1;
                    break;
                }
                if ($$.type == INT_EGER && $3.type == FLOAT_NUM)
                {
                    $$.type = FLOAT_NUM;
                    $$.decimal = $$.integer + $3.decimal;
                    a_op_s = 1;
                    break;
                }
            case 'S':
                    if(tt == 1 || tt2 == 1)
{
            sprintf(astemp,"%s\nT%d = %s",astemp,++Tno,$1);
                sprintf(astemp,"%s\nT%d = T%d - T%d",astemp,++Tno,Tno,Tno-1);
                sprintf(astemp,"%s\n%s = T%d",astemp,$1,Tno);
}
                if ($$.type == FLOAT_NUM && $3.type == FLOAT_NUM)
                {
                    $$.type = FLOAT_NUM;
                    $$.decimal = $$.decimal - $3.decimal;
                    a_op_s = 1;
                    break;
                }
                if ($$.type == INT_EGER && $3.type == FLOAT_NUM)
                {
                    $$.type = FLOAT_NUM;
                    $$.decimal = $$.integer - $3.decimal;
                    a_op_s = 1;
                    break;
                }
            case 'C':
                    if(tt == 1 || tt2 == 1)
{
                sprintf(astemp,"%s\nT%d = %s",astemp,++Tno,$1);
                sprintf(astemp,"%s\nT%d = T%d . T%d",astemp,++Tno,Tno,Tno-1);
                sprintf(astemp,"%s\n%s = T%d",astemp,$1,Tno);
}
                if ($$.type == FLOAT_NUM && $3.type == FLOAT_NUM)
                {
                    $$.type = STR_ING;
                    sprintf($$.string, "%f%f", $$.decimal, $3.decimal);
                    a_op_s = 1;
                    break;
                }
                if ($$.type == INT_EGER && $3.type == FLOAT_NUM)
                {
                    $$.type = STR_ING;
                    sprintf($$.string, "%d%f", $$.integer, $3.decimal);
                    a_op_s = 1;
                    break;
                }
                if ($$.type == STR_ING && $3.type == FLOAT_NUM)
                {
                    $$.type = STR_ING;
                    sprintf($$.string, "%s%f", $$.string, $3.decimal);
                    a_op_s = 1;
                    break;
                }
                tt = 0;
                printf("Error: Operation Not Allowed\n");
                $$.type = NULL_TYPE;
            }
        }

        if ($3.type == STR_ING)
        {
            switch ($2)
            {
            case '=':
                    if(tt == 1 || tt2 == 1)
{
                sprintf(astemp,"%s\n%s %c T%d",astemp,$1,$2,Tno);
}
                $$.type = STR_ING;
                $$.string = $3.string;
                a_op_s = 1;
                break;
            case 'M':
            case 'D':
            case 'P':
            case 'S':
                tt = 0;
                printf("Error: Operation Not Allowed\n");
                $$.type = NULL_TYPE;
                break;
            case 'C':
                if ($$.type == FLOAT_NUM && $3.type == STR_ING)
                {
                    $$.type = STR_ING;
                    sprintf($$.string, "%f%s", $$.decimal, $3.string);
                    a_op_s = 1;
                    break;
                }
                if ($$.type == INT_EGER && $3.type == STR_ING)
                {
                    $$.type = STR_ING;
                    sprintf($$.string, "%d%s", $$.integer, $3.string);
                    a_op_s = 1;
                    break;
                }
                if ($$.type == STR_ING && $3.type == STR_ING)
                {
                    $$.type = STR_ING;
                    sprintf($$.string, "%s%s", $$.string, $3.string);
                    a_op_s = 1;
                    break;
                }
                tt = 0;
                printf("Error: Operation Not Allowed\n");
                $$.type = NULL_TYPE;
            }
        }

        c->data_type = malloc(sizeof(char) * 20);
        c->data_value = malloc(sizeof(char) * 100);
        char a[100];
        if ($$.type == INT_EGER)
        {
            c->data_type = "Integer";
            sprintf(a, "%d", $$.integer);
            memcpy(c->data_value, a, sizeof(a));
        }
        else if ($$.type == FLOAT_NUM)
        {
            c->data_type = "Float";
            sprintf(a, "%f", $$.decimal);
            memcpy(c->data_value, a, sizeof(a));
        }
        else if ($$.type == STR_ING)
        {
            c->data_type = "String";
            sprintf(a, "%s", $$.string);
            memcpy(c->data_value, a, sizeof(a));
        }
        if(a_op_s==1 && inva == 0)
        {
            buildTree("","=","",head);
            //printf(" -[%s]- ",head->name);
            head=head->left;
            buildTree("",c,c->data_value,head);
            head=head->parent;
            a_op_s=0;
        }
    //printf("%s\n",astemp);
    //sprintf(icode,"%s\n%s",astemp);
            if(tt == 1 || tt2 == 1)
{
        free(icode_temp);
        icode_temp = (char*)malloc(sizeof(char)*100);
        sprintf(icode_temp, "%s",astemp);//\n
        // printf("\n%s\n",astemp);
        strcat(icode, icode_temp);//UNCOMMENT
    sprintf(astemp,"");
}
    };




    ITER:ET|ASIGN;
    COND1:EXPR C_OPER1 COND1 {
                if(tt == 1 || tt2 == 1)
{
        sprintf(astemp,"%s\nT%d = T%d %s T%d",astemp,++Tno,$1.tno,copp[$2],$3.tno);
        Cno=Tno;
        sprintf(icode,"%s\n%s",icode,astemp);
        sprintf(astemp,"");
}
        $$.tno=Cno;
        // printf("%d",$$.tno);

    };|EXPR { //printf("%d***",$1.type);$$=$1;
                if(tt == 1 || tt2 == 1)
{
        Cno=Tno;
        sprintf(icode,"%s\n%s",icode,astemp);
        sprintf(astemp,"");
}
        $$.tno=Cno; 
        // printf("%d",$$.tno);
    }

    COND:COND1 {$$=$1;}|COND1 C_OPER COND{
                if(tt == 1 || tt2 == 1)
{
        sprintf(astemp,"%s\nT%d = T%d %s T%d",astemp,++Tno,$1.tno,copp[$2],$3.tno);
        Cno=Tno;
        sprintf(icode,"%s\n%s",icode,astemp);
        sprintf(astemp,"");
}
        $$.tno=Cno;
        // printf("%d",$$.tno);
        
    };



    F_ASIGN:ASIGN|ASIGN T_COMMA F_ASIGN| ;
    F_COND:COND|COND T_COMMA F_COND| ;
    F_ITER:ITER|ITER T_COMMA ITER| ;
    F_CL:T_SEMI_COLON|T_O_CBRAC 
    {buildTree("","","CODE",head);head=head->right;

            free(icode_temp);
            icode_temp = (char*)malloc(sizeof(char)*100);
            sprintf(icode_temp, "\nL%d:", v_l3->label_number+1);
            strcat(icode, icode_temp);
            v_l3 = v_l3->next;

    } CODE {
        
        v_l3 = v_l3->prev;
        free(icode_temp);
        icode_temp = (char*)malloc(sizeof(char)*100);
        sprintf(icode_temp, "GOTO L%d", v_l3->label_number);
        strcat(icode, icode_temp);

        /*head=head->parent;*/
    } T_C_CBRAC {

        v_l3 = v_l3->prev;
        free(icode_temp);
        icode_temp = (char*)malloc(sizeof(char)*100);
        //sprintf(icode_temp, "L%d on %d:\n", v_l3->label_number, ln_num);
        sprintf(icode_temp, "L%d:", v_l3->label_number);
        strcat(icode, icode_temp);

    };




    FOR:T_FOR T_O_NBRAC 
    {buildTree("","ASIGN","",head);head=head->left;} F_ASIGN T_SEMI_COLON 
    {buildTree("","","CONDITION",head);head=head->right;

    e_poi=(node_p*)malloc(sizeof(node_p));
    e_poi->addr=(node*)malloc(sizeof(node));
    e_poi->prev=(node_p*)malloc(sizeof(node_p));
    e_poi->next=(node_p*)malloc(sizeof(node_p));
    e_poi->addr=head;
    e_poi->next->prev=head;
    e_poi=e_poi->next;

    buildTree("","CODE_C","",head);head=head->left;

        //v_l3 = (v_label_node*)malloc(sizeof(v_label_node));
        //v_l3->prev=(v_label_node*)malloc(sizeof(v_label_node));
        v_l3->next = (v_label_node*)malloc(sizeof(v_label_node));
        v_l3->next->prev  = (v_label_node*)malloc(sizeof(v_label_node));
        v_l3->next->prev  = v_l3;
        v_l3->label_number=v_label+2;
        v_l3 = v_l3->next;

        free(icode_temp);
        icode_temp = (char*)malloc(sizeof(char)*100);
        sprintf(icode_temp, "\nL%d:", v_label);
        strcat(icode, icode_temp);
        v_label += 1;


        
    } F_COND {
        free(icode_temp);
        icode_temp = (char*)malloc(sizeof(char)*100);
        sprintf(icode_temp, "\nIF T%d",Cno);//Change to IF
        strcat(icode, icode_temp);

        
        free(icode_temp);
        icode_temp = (char*)malloc(sizeof(char)*100);
        sprintf(icode_temp, " TRUE GOTO L%d ELSE GOTO L%d", v_label, v_label+1);
        strcat(icode, icode_temp);

        v_label+=1;

        //v_l3 = (v_label_node*)malloc(sizeof(v_label_node));
        //v_l3->prev=(v_label_node*)malloc(sizeof(v_label_node));
        v_l3->next = (v_label_node*)malloc(sizeof(v_label_node));
        v_l3->next->prev  = (v_label_node*)malloc(sizeof(v_label_node));
        v_l3->next->prev  = v_l3;
        v_l3->label_number=v_label-2;

        v_label+=1;
        
        e_poi=e_poi->prev;head=e_poi;} T_SEMI_COLON 
    {buildTree("","","ITER",head);head=head->right;} F_ITER {head=head->parent;/**/head=head->parent;/**/head=head->parent;} 
    T_C_NBRAC F_CL;







    WHILE:T_WHILE T_O_NBRAC 
    {buildTree("","CONDITION","",head);head=head->left;

    e_poi=(node_p*)malloc(sizeof(node_p));
    e_poi->addr=(node*)malloc(sizeof(node));
    e_poi->prev=(node_p*)malloc(sizeof(node_p));
    e_poi->next=(node_p*)malloc(sizeof(node_p));
    e_poi->addr=head;
    e_poi->next->prev=head;
    e_poi=e_poi->next;

    buildTree("","CODE_C","",head);head=head->left;


        //v_l3 = (v_label_node*)malloc(sizeof(v_label_node));
        //v_l3->prev=(v_label_node*)malloc(sizeof(v_label_node));
        v_l4->next = (v_label_node*)malloc(sizeof(v_label_node));
        v_l4->next->prev  = (v_label_node*)malloc(sizeof(v_label_node));
        v_l4->next->prev  = v_l4;
        v_l4->label_number=v_label+2;
        v_l4 = v_l4->next;

        free(icode_temp);
        icode_temp = (char*)malloc(sizeof(char)*100);
        sprintf(icode_temp, "\nL%d:", v_label);
        strcat(icode, icode_temp);
        v_label += 1;





    } COND {
                free(icode_temp);
        icode_temp = (char*)malloc(sizeof(char)*100);
        sprintf(icode_temp, "\nIF T%d",Cno);//Change to IF
        strcat(icode, icode_temp);
        free(icode_temp);
        icode_temp = (char*)malloc(sizeof(char)*100);
        sprintf(icode_temp, " TRUE GOTO L%d ELSE GOTO L%d", v_label, v_label+1);
        strcat(icode, icode_temp);

        v_label+=1;

        //v_l3 = (v_label_node*)malloc(sizeof(v_label_node));
        //v_l3->prev=(v_label_node*)malloc(sizeof(v_label_node));
        v_l4->next = (v_label_node*)malloc(sizeof(v_label_node));
        v_l4->next->prev  = (v_label_node*)malloc(sizeof(v_label_node));
        v_l4->next->prev  = v_l4;
        v_l4->label_number=v_label-2;

        v_label+=1;
        
        
        e_poi=e_poi->prev;head=e_poi;/*head=head->parent;*/} T_C_NBRAC T_O_CBRAC 
    {buildTree("","","CODE",head);head=head->right;

            free(icode_temp);
            icode_temp = (char*)malloc(sizeof(char)*100);
            sprintf(icode_temp, "\nL%d:", v_l4->label_number+1);
            strcat(icode, icode_temp);
            v_l4 = v_l4->next;

    } CODE {
        
        v_l4 = v_l4->prev;
        free(icode_temp);
        icode_temp = (char*)malloc(sizeof(char)*100);
        sprintf(icode_temp, "\nGOTO L%d", v_l4->label_number);
        strcat(icode, icode_temp);

        /*head=head->parent;/*head=head->parent;*/} T_C_CBRAC 
    {
        
        v_l4 = v_l4->prev;
        free(icode_temp);
        icode_temp = (char*)malloc(sizeof(char)*100);
        sprintf(icode_temp, "\nL%d:", v_l4->label_number);
        strcat(icode, icode_temp);

        /*head=head->parent;*/
    };





    ELSE:T_ELSE {
        buildTree("","","ELSE",head);head=head->right;} T_O_CBRAC 
    {/*printf(" -[%s]- ",head->parent->right->name)*/;buildTree("","","CODE",head);head=head->right;} CODE {/*head=head->parent;*/} T_C_CBRAC 
    {/*head=head->parent;*/};







    ELSEIF:T_ELSEIF {

        
        buildTree("","","ELSEIF",head);head=head->right;} T_O_NBRAC 
    {buildTree("","CONDITION","",head);head=head->left;

    e_poi=(node_p*)malloc(sizeof(node_p));
    e_poi->addr=(node*)malloc(sizeof(node));
    e_poi->prev=(node_p*)malloc(sizeof(node_p));
    e_poi->next=(node_p*)malloc(sizeof(node_p));
    e_poi->addr=head;
    e_poi->next->prev=head;
    e_poi=e_poi->next;

    buildTree("","CODE_C","",head);head=head->left;} COND {
        
        free(icode_temp);
        icode_temp = (char*)malloc(sizeof(char)*100);
        sprintf(icode_temp, "\nIF T%d",Cno);//Change to IF
        strcat(icode, icode_temp);

        free(icode_temp);
        icode_temp = (char*)malloc(sizeof(char)*100);
        sprintf(icode_temp, " TRUE GOTO L%d ELSE GOTO L%d", v_label, v_label+1);
        strcat(icode, icode_temp);

        v_label+=1;

        //v_l = (v_label_node*)malloc(sizeof(v_label_node));
        //v_l->prev=(v_label_node*)malloc(sizeof(v_label_node));
        v_l->next = (v_label_node*)malloc(sizeof(v_label_node));
        v_l->next->prev  = (v_label_node*)malloc(sizeof(v_label_node));
        v_l->next->prev  = v_l;
        v_l->label_number=v_label;

        v_label+=1;
        
        
        
        e_poi=e_poi->prev;head=e_poi;/*head=head->parent;*/
    } T_C_NBRAC T_O_CBRAC {

            free(icode_temp);
            icode_temp = (char*)malloc(sizeof(char)*100);
            sprintf(icode_temp, "\nL%d:", v_l->label_number-1);
            strcat(icode, icode_temp);
            v_l = v_l->next;

        buildTree("","","CODE",head);head=head->right;} CODE {

            free(icode_temp);
            icode_temp = (char*)malloc(sizeof(char)*100);
            sprintf(icode_temp, "\nGOTO L%d", v_l2->label_number);
            strcat(icode, icode_temp);
            //go up l8r when done with if elseif else

            /*head=head->parent;/*head=head->parent;*/} T_C_CBRAC {

            v_l = v_l->prev;
            free(icode_temp);
            icode_temp = (char*)malloc(sizeof(char)*100);
            sprintf(icode_temp, "\nL%d:", v_l->label_number);
            strcat(icode, icode_temp);

    } I_OP 
    {
        /*head=head->parent;*/
    };




    I_OP:ELSEIF|ELSE {
                free(icode_temp);
                icode_temp = (char*)malloc(sizeof(char)*100);
                sprintf(icode_temp, "\nL%d:", v_l2->label_number);
                strcat(icode, icode_temp);
            }| {
                free(icode_temp);
                icode_temp = (char*)malloc(sizeof(char)*100);
                sprintf(icode_temp, "\nL%d:", v_l2->label_number);
                strcat(icode, icode_temp);
            };








    IF:T_IF {


    } T_O_NBRAC 
    {buildTree("","CONDITION","",head);head=head->left;

    e_poi=(node_p*)malloc(sizeof(node_p));
    e_poi->addr=(node*)malloc(sizeof(node));
    e_poi->prev=(node_p*)malloc(sizeof(node_p));
    e_poi->next=(node_p*)malloc(sizeof(node_p));
    e_poi->addr=head;
    e_poi->next->prev=head;
    e_poi=e_poi->next;

    buildTree("","CODE_C","",head);head=head->left;} COND {

        free(icode_temp);
        icode_temp = (char*)malloc(sizeof(char)*100);
        sprintf(icode_temp, "\nIF T%d",Cno);
        strcat(icode, icode_temp);

        free(icode_temp);
        icode_temp = (char*)malloc(sizeof(char)*100);
        sprintf(icode_temp, " TRUE GOTO L%d ELSE GOTO L%d", v_label, v_label+2);
        strcat(icode, icode_temp);

        v_label+=1;

        //v_l = (v_label_node*)malloc(sizeof(v_label_node));
        //v_l->prev=(v_label_node*)malloc(sizeof(v_label_node));
        v_l->next = (v_label_node*)malloc(sizeof(v_label_node));
        v_l->next->prev  = (v_label_node*)malloc(sizeof(v_label_node));
        v_l->next->prev  = v_l;
        v_l->label_number=v_label+1;

        v_label+=1;

        v_l2 = v_l2->next;
        //v_l2 = (v_label_node*)malloc(sizeof(v_label_node));
        //v_l2->prev=(v_label_node*)malloc(sizeof(v_label_node));
        v_l2->next = (v_label_node*)malloc(sizeof(v_label_node));
        v_l2->next->prev  = v_l2;
        v_l2->label_number=v_label-1;

        v_label+=1;


        e_poi=e_poi->prev;head=e_poi;/*printf(" -[%s]-! \n", head->name);/*;/*head=head->parent;*/
        } T_C_NBRAC T_O_CBRAC {
            
            free(icode_temp);
            icode_temp = (char*)malloc(sizeof(char)*100);
            sprintf(icode_temp, "\nL%d:", v_l->label_number-2);
            strcat(icode, icode_temp);
            v_l = v_l->next;

        buildTree("","","CODE",head);head=head->right;} CODE {
        
            free(icode_temp);
            icode_temp = (char*)malloc(sizeof(char)*100);
            sprintf(icode_temp, "\nGOTO L%d", v_l2->label_number);
            strcat(icode, icode_temp);
            //go up l8r when done with if elseif else
        
        /*head=head->parent;/*head=head->parent;*/} T_C_CBRAC {

            v_l = v_l->prev;
            free(icode_temp);
            icode_temp = (char*)malloc(sizeof(char)*100);
            sprintf(icode_temp, "\nL%d:", v_l->label_number);
            strcat(icode, icode_temp);
            }
    I_OP 
    {
        v_l2 = v_l2->prev;
        //printf("\n--------GOTO L%d\n", v_l2->label_number);
        /*head=head->parent;*/
    };















    CODE:
    {   
        tt2 = 1;
        buildTree("","FOR","CODE",head);head=head->left;} FOR {head=head->parent;
    poi=(node_p*)malloc(sizeof(node_p));
    poi->addr=(node*)malloc(sizeof(node));poi->prev=(node_p*)malloc(sizeof(node_p));poi->next=(node_p*)malloc(sizeof(node_p));
    poi->addr=head;poi->next->prev=head;poi=poi->next;
    head=head->right;} CODE {poi=poi->prev;head=poi;}|
    {
        tt2 = 1;
        buildTree("","WHILE","CODE",head);head=head->left;} WHILE {head=head->parent;
    poi=(node_p*)malloc(sizeof(node_p));
    poi->addr=(node*)malloc(sizeof(node));poi->prev=(node_p*)malloc(sizeof(node_p));poi->next=(node_p*)malloc(sizeof(node_p));
    poi->addr=head;poi->next->prev=head;poi=poi->next;
    head=head->right;} CODE {poi=poi->prev;head=poi;}|
    {
        tt2 = 1;
        buildTree("","IF","CODE",head);head=head->left;} IF {head=head->parent;
    poi=(node_p*)malloc(sizeof(node_p));
    poi->addr=(node*)malloc(sizeof(node));poi->prev=(node_p*)malloc(sizeof(node_p));poi->next=(node_p*)malloc(sizeof(node_p));
    poi->addr=head;poi->next->prev=head;poi=poi->next;
    head=head->right;} CODE {poi=poi->prev;head=poi;}|
    {
        tt2 = 1;
        /*printf(" -[%s]- ",head->name);*/
        ep_op = 1;buildTree("","ECHO","CODE",head);head=head->left;} ECHO {ep_op = 0;head=head->parent;
    poi=(node_p*)malloc(sizeof(node_p));
    poi->addr=(node*)malloc(sizeof(node));poi->prev=(node_p*)malloc(sizeof(node_p));poi->next=(node_p*)malloc(sizeof(node_p));
    poi->addr=head;poi->next->prev=head;poi=poi->next;
    head=head->right;} CODE {poi=poi->prev;head=poi;}|
    {
        tt2 = 1;
        ep_op = 1;buildTree("","PRINT","CODE",head);head=head->left;} PRINT {ep_op = 0;head=head->parent;
    poi=(node_p*)malloc(sizeof(node_p));
    poi->addr=(node*)malloc(sizeof(node));poi->prev=(node_p*)malloc(sizeof(node_p));poi->next=(node_p*)malloc(sizeof(node_p));
    poi->addr=head;poi->next->prev=head;poi=poi->next;
    head=head->right;} CODE {poi=poi->prev;head=poi;}| 
    {tt2 = 1;} T_NEW_LINE CODE| {tt2 = 1;} T_CR CODE| {tt2 = 1;} T_SEMI_COLON CODE| {tt2 = 1;} T_WHITESPACE CODE|
    {
        tt2 = 1;
        buildTree("","ITER_ASIGN","CODE",head);head=head->left;} ITER {head=head->parent;
    poi=(node_p*)malloc(sizeof(node_p));
    poi->addr=(node*)malloc(sizeof(node));poi->prev=(node_p*)malloc(sizeof(node_p));poi->next=(node_p*)malloc(sizeof(node_p));
    poi->addr=head;poi->next->prev=head;poi=poi->next;
    head=head->right;} T_SEMI_COLON CODE {poi=poi->prev;head=poi;}| ;


    end:T_CLOSE_TAG;

    %%

    void init_hash_table()
    {
        int i;
        hash_table = malloc(SIZE * sizeof(list_t *));
        for (i = 0; i < SIZE; i++)
        {
            hash_table[i] = NULL;
        }
    }

    unsigned int hash(char *key)
    {
        unsigned int hashval = 0;
        for (; *key != '\0'; key++)
        {
            hashval += *key;
        }
        hashval += key[0] % 11 + (key[0] << 3) - key[0];
        return hashval % SIZE;
    }

    void insert(char *name, int len, int type, int lineno, int c_scope)
    {
        unsigned int hashval = hash(name);
        list_t *l = hash_table[hashval];

        while ((l != NULL) && (strcmp(name, l->st_name) != 0))
        {
            l = l->next;
        }
        if (l == NULL)
        {
            l = (list_t *)malloc(sizeof(list_t));
            strncpy(l->st_name, name, len);
            l->st_type = type;
            l->scope = c_scope;
            l->lines = (RefList *)malloc(sizeof(RefList));
            l->lines->lineno = lineno;
            l->lines->next = NULL;
            l->next = hash_table[hashval];
            hash_table[hashval] = l;
            //printf("Inserted Identifier: %s [at line number %d]\n", name, lineno);
        }
        else
        {
            l->scope = c_scope;
            RefList *t = l->lines;
            while (t->next != NULL)
                t = t->next;
            t->next = (RefList *)malloc(sizeof(RefList));
            t->next->lineno = lineno;
            t->next->next = NULL;
            //printf("Encountered Again: %s [at line number %d]\n", name, lineno);
        }
    }

    list_t *lookup(char *name)
    {
        unsigned int hashval = hash(name);
        list_t *l = hash_table[hashval];
        while ((l != NULL) && (strcmp(name, l->st_name) != 0))
        {
            l = l->next;
        }
        //printf("%s",l);
        return l;
    }

    void s_current_lookup(char *idi)
    { 
        free(current_i);
        current_i = malloc(sizeof(char) * 20);
        memcpy(current_i, idi, sizeof(idi));
        update = 1;
    }

    char *r_current_lookup()
    {
        if (update == 1 && valid == 1)
        {
            update = 0;
            return current_i;
        }
    }

    void e_vld(int vld)
    {
        valid = vld;
    }




    snode* new_sn()
    {
        snode* t = (snode*)malloc(sizeof(snode));
        t->nf = 0;
        t->next = NULL;
        return t;
    }

    void bn(char *op)
    {
        if(nic != pnic)
        {
            list_root->next = new_sn();
            list_root = list_root->next;
            list_root->ln = ln_num;
            pnic = nic;
            no_of_sn += 1;
        }
        list_root->t_nodes[list_root->nf] = (char*)malloc(sizeof(char)*50);
        list_root->t_nodes[list_root->nf] = op;
        if(list_root->nf % 3 == 5 && list_root->nf != 3 && list_root->nf != 3)
        {

        }
        else
        {
            //list_root->t_nodes[list_root->nf] = (char*)malloc(sizeof(char)*50);
            //list_root->t_nodes[list_root->nf] = op;
        }
        //printf("\n (%s) ", op);
        list_root->nf += 1;
    }

    void p_sn()
    {
        for(int i = 0; i < no_of_sn; i++)
        {
            //printf("%d",l_root->nf);
            for(int j = 0; j < l_root->nf; j++)
            {
                printf("\n%s --- %d ", l_root->t_nodes[j], l_root->ln);
            }
            l_root=l_root->next;
            printf("\n-----------------\n");
        }
    }


    void strreplace(char string[], char search[], char replace[]){
        char buffer[20002];
        char*p = string;
        while(p=strstr(p, search))
        {
            strncpy(buffer, string, p-string);
            buffer[p-string] = '\0';
            strcat(buffer, replace);
            strcat(buffer, p+strlen(search));
            strcpy(string, buffer);
            p++;
        }
    } 


    node* buildTree(char *op,char *left,char *right, node* new1)
    {
        
        if(nnn == 1)
        {
            node *new12 = (node*)malloc(sizeof(node));
            new12->name = (char*)malloc(sizeof(char)*(strlen(op)+1));
            new12->parent=NULL;
            new12->name = op;
            nnn = 0;
            new1 = new12;
        }
        else{
            ;//printf(" ---[%s]- \n", new1->name);
        }
        
        //new1->left=(node*)malloc(sizeof(node));
        //new1->left->name = (char*)malloc(sizeof(char)*(strlen(left)+1));
        if(left != "")
        {
            new1->left=(node*)malloc(sizeof(node));
            new1->left->parent=(node*)malloc(sizeof(node));
            new1->left->parent=new1;
            new1->left->name = (char*)malloc(sizeof(char)*(strlen(left)+1));
            new1->left->name = left;
        }
        else
        {
            if(new1->left == NULL)
            {
                new1->left=(node*)malloc(sizeof(node));
                new1->left->parent=(node*)malloc(sizeof(node));
                new1->left->parent=new1;
                //new1->left->name = (char*)malloc(sizeof(char)*(strlen(left)+1));
                //new1->left->name = left;
            }
        }
        //new1->right=(node*)malloc(sizeof(node));
        //new1->right->name = (char*)malloc(sizeof(char)*(strlen(right)+1));
        if(right != "")
        {
            new1->right=(node*)malloc(sizeof(node));
            new1->right->parent=(node*)malloc(sizeof(node));
            new1->right->parent=new1;
            new1->right->name = (char*)malloc(sizeof(char)*(strlen(right)+1));
            new1->right->name = right;  
        }
        else
        {
            if(new1->right == NULL)
            {
                new1->right=(node*)malloc(sizeof(node));
                new1->right->parent=(node*)malloc(sizeof(node));
                new1->right->parent=new1;
                //new1->right->name = (char*)malloc(sizeof(char)*(strlen(right)+1));
                //new1->right->name = right;  
            }
        }
        return new1;
    }

    void printTree(node *tree)
    {
        //printf(" [L]%s [N]%s [R]%s",tree->left->name ,tree->name ,tree->right->name);
        if(tree!=NULL)
        {
            printTree(tree->left);
            if(tree->name != NULL)
            {
                printf("[%s]  ",tree->name);
            }
            printTree(tree->right);
        }
        else
        {
            return;
        }
        /*
        if(tree->left || tree->right)
            printf("(");
        printf(" %s ",tree->name);
        if(tree->left)
            printTree(tree->left);
        if(tree->right)
            printTree(tree->right);
        if(tree->left || tree->right)
            printf(")");	
        */
    }

    void display_icg()
    {
        if(quadnum > 0)
        {
            printf("\nIntermediate Code:\n\n");


            printf("\n----------------------------------------\n");
            printf("\nIntermediate Code Generation - Quadruples\n\n");
            printf("\tResult:\t\t Operator:\t Arg1:\t\t Arg2:\t\t \n");
            for(int i=0;i<quadnum;i++)
            {
                    printf("\t%s \t\t %s \t\t %s \t\t %s \t\t \n",q[i].res,q[i].op,q[i].arg1,q[i].arg2);
            }	
        }
        
    }

    void push(char *string)	
    {
        strcpy(stk[++tops], string);
    }

    void codeGenerator(char*op,char*arg1,char*arg2,char*result)
    {
            if(!isConditional)
            {
                tuple[tupleIndex].line=ln_num;      
                tuple[tupleIndex].op=op;
                tuple[tupleIndex].arg1=arg1;
                tuple[tupleIndex].arg2=arg2;
                tuple[tupleIndex].result=result;
                tupleIndex++;
            }
    }

    void file_write_data(const char *filepath, const char *data)
    {
        FILE *fp = fopen(filepath, "wb");
        if (fp != NULL)
        {
            fputs(data, fp);
            fclose(fp);
        }
    }

    char* newTemp()
    {
            temporaryGenerated++;
            char *temp=(char *)malloc(sizeof(2*10));
            sprintf(temp,"t%d",temporaryGenerated);
            return temp;
    }

    void newICG(int index)
    {
        q[index].op = (char*)malloc(sizeof(char)*100);
        q[index].arg1 = (char*)malloc(sizeof(char)*100);
        q[index].arg2 = (char*)malloc(sizeof(char)*100);
        q[index].res = (char*)malloc(sizeof(char)*100);
    }

    void symtab_dump(FILE *of, int dp)
    {
        int i;
        if (dp == 0)
        {
            fprintf(of, "\n[Symbol Table Update: %d]\n", nor);
        }
        else
        {
            fprintf(of, "\n[Final Symbol Table]\n");
        }
        nor += 1;
        fprintf(of, "____________________________________________________________________________________________________________________ \n");
        fprintf(of, " Identifier | Data Type |   Data Value                 |   Scope | Line Numbers   \n");
        fprintf(of, "‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾ \n");
        for (i = 0; i < SIZE; ++i)
        {
            if (hash_table[i] != NULL)
            {
                list_t *l = hash_table[i];
                while (l != NULL)
                {
                    RefList *t = l->lines;
                    fprintf(of, "%-14s ", l->st_name);
                    if (lookup(l->st_name)->data_value == NULL)
                    {
                        fprintf(of, "%-15s ", "UNDEF");
                    }
                    else
                    {
                        fprintf(of, "%-15s ", lookup(l->st_name)->data_type);
                    }
                    if (lookup(l->st_name)->data_value == NULL)
                    {
                        fprintf(of, "%-30s", "UNDEF");
                    }
                    else
                    {
                        fprintf(of, "%-30s", lookup(l->st_name)->data_value);
                    }
                    fprintf(of, "%-12d", lookup(l->st_name)->scope);
                    while (t != NULL)
                    {
                        fprintf(of, "%4d ", t->lineno);
                        t = t->next;
                    }
                    fprintf(of, "\n");
                    l = l->next;
                }
            }
        }
    }

    void yyerror()
    {
        tt = 0;
        tt2 = 0;
        printf("Error on line no: %d\n", ln_num);
        //exit(0);
    }

    void addicref (icref* icroot,char* index, char* ictext){
        if(icroot->next){
            addicref(icroot->next,index,ictext);
        }
        else{
            icref* ic;
            ic=(icref*)malloc(sizeof(icref));
            sprintf(ic->index,"%s",index);
            sprintf(ic->ic,"%s",ictext);
            // icroot->next=ic;
            icroot->next=ic;
        }

    }

    char* lookicref (icref* icroot,char* index){
        if(icroot->index==index){
            return icroot->ic;
        }
        
        if(icroot->next){
            char* a=lookicref(icroot->next,index);
            return a;}
        return -1;

    }

    void* printicref(icref* root){
    if(root){
        printf("%s --- %s\n",root->index,root->ic);
        printicref(root->next);
    }

    }
    int main(int argc, char *argv[])
    {
        int flag;
        icref *icroot=(icref*) malloc(sizeof(icref));
        icode = (char*)malloc(sizeof(char)*10000);
        icode_prev = (char*)malloc(sizeof(char)*100);

        
        v_l = (v_label_node*)malloc(sizeof(v_label_node));
        v_l->prev=(v_label_node*)malloc(sizeof(v_label_node));
        v_l->next=(v_label_node*)malloc(sizeof(v_label_node));
        //v_l->prev = NULL;
        v_l->next->prev = (v_label_node*)malloc(sizeof(v_label_node));
        v_l->next->prev = v_l;
        v_l = v_l->next;

    //---
        v_l3 = (v_label_node*)malloc(sizeof(v_label_node));
        v_l3->prev=(v_label_node*)malloc(sizeof(v_label_node));
        v_l3->next=(v_label_node*)malloc(sizeof(v_label_node));
        //v_l3->prev = NULL;
        v_l3->next->prev = (v_label_node*)malloc(sizeof(v_label_node));
        v_l3->next->prev = v_l3;
        v_l3 = v_l3->next;


        v_l4 = (v_label_node*)malloc(sizeof(v_label_node));
        v_l4->prev=(v_label_node*)malloc(sizeof(v_label_node));
        v_l4->next=(v_label_node*)malloc(sizeof(v_label_node));
        //v_l4->prev = NULL;
        v_l4->next->prev = (v_label_node*)malloc(sizeof(v_label_node));
        v_l4->next->prev = v_l4;
        v_l4 = v_l4->next;
    //---
        
        v_l2 = (v_label_node*)malloc(sizeof(v_label_node));
        v_l2->prev=(v_label_node*)malloc(sizeof(v_label_node));
        v_l2->next=(v_label_node*)malloc(sizeof(v_label_node));
        //v_l2->prev = NULL;
        v_l2->next->prev  = (v_label_node*)malloc(sizeof(v_label_node));
        v_l2->next->prev  = v_l2;
        //v_l2 = v_l2->next;

        strcat(icode, "");


        list_root = (snode*)malloc(sizeof(snode));
        l_root = list_root;

        init_hash_table();
        yyout = fopen("symbol_table.txt", "w");
        flag = yyparse();
        //printicref(icroot);
        if(p_ast == 0)
        {
            printf("\n\n\n-------Abstract Syntax Tree - Inorder Traversal-------\n\n");
            printTree(root);
            p_ast=1;
            printf("\n\n");
        };
        //p_sn();
        //display_icg();
        strreplace(icode, "\n\n", "\n");
        printf("\n\n\n-------Intermediate Code-------\n");
        printf("\n%s\n\n--------------------------\n", icode);
        strcat(icode, "\n");
        if (icode[0] == '\n') 
        {
            icode++;
        }
        file_write_data("intermediate_code.txt", icode);
        if (tt == 1)
        {
            printf("\n\n--------------------------\nValid.\n\n");
        }
        else
        {
            printf("\n\n--------------------------\nInvalid.\n\n");
        }
        symtab_dump(yyout, 0);
        fclose(yyout);
        yyout = fopen("symbol_table_final.txt", "w");
        symtab_dump(yyout, 1);
        fclose(yyout);
        return flag;
    }
