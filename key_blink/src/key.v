module key(
    input  [1:0]            key,
    output  key_output
); 

assign key_output = (~key[0])|(~key[1])  ;

endmodule