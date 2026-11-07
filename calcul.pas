program calcul;
uses
	SysUtils, math;
 
const MAXINT =  2147483647;
type t = record
			resnum: longint;
			resdenom: longword;
		end;
var
	i, j: integer;
	s: char;
	base: integer;
	denom: longword;
	num: longint;
	oper: char;
	result: t;
	r: string;
	flag_finish: boolean;
{
Процедура, считывающая посимвольно и проверяющая,
	что вводится следующий символ слова 'finish'
}
procedure try_finish(var flag_finish: boolean);
var s: char;
begin
	read(s);
	if (s <> 'i') and (s <> 'I') then
	begin
		writeln('miss');
		halt;
	end;
	read(s);
	if (s <> 'n') and (s <> 'N') then
	begin 
		writeln('miss');
		halt;
	end;
	read(s);
	if (s <> 'i') and (s <> 'I') then
	begin
		writeln('miss');
		halt;
	end;
	read(s);
	if (s <> 's') and (s <> 'S') then
	begin
		writeln('miss');
		halt;
	end;
	read(s);
	if (s <> 'h') and (s <> 'H') then
	begin
		writeln('miss');
		halt;
	end;
	flag_finish := False;
end;

{
Процедура, считывающая посимвольно пробелы и операцию и проверяющая,
	что вводится допустимые символы. В ином случае, выводит ошибку и заканчивает программу
	Если же видит символ 'F' или 'f', вызывает функцию, проверяющую не 'finish' ли это
}
procedure read_oper(var i: integer; var oper: char; var flag_finish: boolean);
	var
		s: char;
	begin
		read(s);
		while (s <> '#') or (ord(s) <> 10) do
		begin
			if s = '+' then
			begin
				oper := '+';
				break;
			end 
			else if s = '-' then
			begin
				oper := '-';
				break;
			end
			else if s = '*' then
			begin
				oper := '*';
				break;
			end
			else if s = '/' then
			begin
				oper := '/';
				break;
			end
			else if (s = 'f') or (s = 'F') then
			begin
				try_finish(flag_finish);
				break;
			end
			else if s <> ' ' then
			begin
				writeln('mistake in column ', i);
				halt;
			end;
			i := i + 1;
			read(s);
		end;
	end;

{
Процедура, считывающая посимвольно систему счисления и проверяющая корректность символов 
}
procedure read_base(var i: integer; var base: integer);
	var
		s: char;
	begin
		read(s);
		base := 0;
		while (ord(s) <> 10) and (s <> ':') do
		begin
			if (s >= '0') and (s <= '9') then base := base * 10 + (ord(s) - ord('0'))
			else if s <> ' ' then
			begin 
				writeln('mistake in column ', i);
				halt;
			end;
			i := i + 1;	
			read(s);
		end;
		if ord(s) = 10 then
		begin
			writeln('mistake ne vveli chislo');
			halt;
		end;
		if base > 512 then
		begin
			writeln('slishkom bolshaya baza');
			halt;
		end;
	end;


{
Процедура, считывающая посимвольно числитель со знаком и проверяющая корректность символов.
	также проверяет переполнение.
}
procedure read_num(var base: integer; var i: integer; var num: longint);
	var 
		s: char;
		intch, flag: integer;
	begin
		num := 0;
		intch := 0;
		read(s);
		flag := 1;
		while (ord(s) <> 10) and (s <> '/') do
		begin
			if s = '-' then flag := 0
			else if (s >= '0') and (s <= '9') then
			begin
				intch := 100 * (ord(s) - ord('0'));
				read(s);
				if (s < '0') or (s > '9') then
				begin
					writeln('norm chislo pishite pg');
					halt;
				end;
				intch := intch + 10 * (ord(s) - ord('0'));
				read(s);
				if (s < '0') or (s > '9') then
				begin
					writeln('norm chislo pishite pg');
					halt;
				end;
				intch := intch + (ord(s) - ord('0'));
				i := i + 2;
				if intch >= base then
				begin
					writeln('mistake v chisle');
					halt;
				end;
				if num > (MAXINT - intch) / base then
				begin
					writeln('slishkom bolshoy chislitel');
					halt;
				end;
				if num < (((-1)*MAXINT - 1) - intch) / base then
				begin
					writeln('slishkom malenkiy chislitel');
					halt;
				end;
				num := num * base + intch;
				intch := 0;
			end
			else if (s <> ' ') and (s <> '+') then 
			begin
				writeln('mistake v stolbce', i);
				halt;
			end;
			i := i + 1;
			read(s);
		end;
		if ord(s) = 10 then
		begin
			writeln('gde denomenator???');
			halt;
		end;
		if flag = 0 then num := (-1)*num;
	end;


{
Процедура, считывающая посимвольно знаменатель и проверяющая корректность символов.
	также проверяет переполнение и деление на ноль.
}
procedure read_denom(var base: integer; var i: integer; var denom: longword);
	var 
		s: char;
		intch: integer;
	begin
		intch := 0;
		read(s);
		while (ord(s) <> 10) and (s <> '#') do
		begin
			if (s >= '0') and (s <= '9') then
			begin
				intch := 100 * (ord(s) - ord('0'));
				read(s);
				if (s < '0') or (s > '9') then
				begin
					writeln('norm chislo pishite pg');
					halt;
				end;
				intch := intch + 10 * (ord(s) - ord('0'));
				read(s);
				if (s < '0') or (s > '9') then
				begin
					writeln('norm chislo pishite pg');
					halt;
				end;
				intch := intch + (ord(s) - ord('0'));
				if intch >= base then
				begin
					writeln('mistake v chisle');
					halt;
				end;
				if denom > (longword.MaxValue - intch) / base then
				begin
					writeln('slishkom bolshoy znamenatel');
					halt;
				end;
				denom := denom * base + intch;
			end
			else if s <> ' ' then
			begin
				writeln('mistake v stolbce', i);
				halt;
			end;
			i := i + 1;
			read(s);
		end;
		if s = '#' then
		begin
			while ord(s) <> 10 do read(s);
		end;
		if denom = 0 then
		begin
			writeln('mistake denom = 0');
			halt;
		end;
	end;
{
Процедура, сокращающая дроби
}
procedure reduce(var result: t{; var num: longint; var denom: longword});
	var a: longint;
		b: longword;
	begin
		if result.resnum = (MAXINT*(-1) - 1) then halt;
		a := abs(result.resnum);
		b := abs(result.resdenom);
		while (a mod b <> 0) and (b mod a <> 0) do
		begin
			if a > b then a := a mod b
			else b := b mod a;
		end;
		if a > b then a := b;
		result.resnum := result.resnum div a;
		result.resdenom := result.resdenom div a;
	end;

{
Процедура '+' с учетом переполнения
}							
procedure add_num(var result: t; var num: longint; var denom: longword);
		begin
			if result.resnum * denom > MAXINT - result.resdenom * num then
			begin
				writeln('too much');
				halt;
			end;
			result.resnum := result.resnum * denom + result.resdenom * num;
			if result.resdenom > longword.MaxValue div denom then
			begin
				writeln('bolshoy denom');
				halt;
			end;
			result.resdenom := result.resdenom * denom;
			reduce(result);
			writeln(result.resnum, '/', result.resdenom);
			writeln();
		end;


{
Процедура '-' с учетом переполнения
}
procedure subtract_num(var result: t; var num: longint; var denom: longword);
		begin
			if result.resnum * denom < ((-1)*MAXINT - 1) + result.resdenom * num then
			begin
				writeln('malenkoe chislo');
				halt;
			end;
			result.resnum := result.resnum * denom - result.resdenom * num;
			if result.resdenom > longword.MaxValue div denom then
			begin
				writeln('bolshoy denom');
				halt;
			end;
			result.resdenom := result.resdenom * denom;
			reduce(result);
			writeln(result.resnum, '/', result.resdenom);
			writeln();
		end;

{
Процедура '*' с учетом переполнения
}
procedure mult_num(var result: t; num: longint; denom: longword);
		begin
			if num <> 0 then
			begin
				if (result.resnum > 0) and (result.resnum > MAXINT div num) then 
				begin 
					writeln('slichkom mnogo'); 
					halt; 
				end;
				if (result.resnum < 0) and (result.resnum < ((-1)*MAXINT - 1) div num) then
				begin 
					writeln('slichkom malo'); 
					halt; 
				end;
			end;
			result.resnum := result.resnum * num;
			if result.resdenom > longword.MaxValue div denom then
			begin
				writeln('bolshoy denom'); 
				halt; 
			end;
			result.resdenom := result.resdenom * denom;
			reduce(result);
			writeln(result.resnum, '/', result.resdenom);
		end;
{
Процедура '/' с учетом переполнения
}
procedure divide_num(var result: t; num: longint; denom: longword);
		begin
		if num = 0 then 
			begin
			writeln('dell na null');
			halt;
			end;
		if denom <> 0 then 
		begin
			if (result.resnum > 0) and (result.resnum > MAXINT div denom) then
			begin
				writeln('slichkom mnogo');
				halt;
			end;
			if (result.resnum < 0) and (result.resnum < ((-1)*MAXINT - 1) div denom) then 
			begin 
				writeln('slichkom malo'); 
				halt; 
			end;
		end;
		result.resnum := result.resnum * denom;
		if result.resdenom > longword.MaxValue div denom then
			begin 
				writeln('bolshoy denom');
				halt;
			end;
		result.resdenom := result.resdenom * abs(num);
		reduce(result);
		writeln(result.resnum, '/', result.resdenom);
		end;
{
Процедура, выводящая в правильном формате числитель
}				
procedure write_num(base: integer; num: longint);
begin
	if num <> 0 then
	begin
		write_num(base, num div base);
		if (num mod base < 10) then write('00', num mod base, ' ')
		else if (num mod base < 100) then write('0', num mod base, ' ')
		else if (num mod base < 1000) then write(num mod base, ' ');
	end;
end;
{
Процедура, выводящая в правильном формате знаменатель
}
procedure write_denom(base: integer; num: longword);
begin
	if num <> 0 then
	begin
		write_denom(base, num div base);
		if (num mod base < 10) then write('00', num mod base, ' ')
		else if (num mod base < 100) then write('0', num mod base, ' ')
		else if (num mod base < 1000) then write(num mod base, ' ');
	end;
end;
{
Процедура, выводящая в правильном формате число
}
procedure write_result(base: integer; result: t);
begin
	write(base, ':');
	if result.resnum = 0 then write('000 ');
	if result.resnum < 0 then
	begin 
		write('-');
		result.resnum := abs(result.resnum);
	end;
	write_num(base, result.resnum);
	write('/ ');
	write_denom(base, result.resdenom);
	writeln;
end;


begin
	result.resnum := 0;
	denom := 0;
	num := 0;
	base := 0;
	result.resdenom := 1;
	i := 1;
	oper := '.';
	s := ' ';
	flag_finish := True;
	
	while flag_finish = True do
	begin 
		denom := 0;
		num := 0;
		s := ' ';
		base := 0;
		read_oper(i, oper, flag_finish);
		if flag_finish = False then break;
		i := i + 1;
		read_base(i, base);
		i := i + 1; 
		read_num(base, i, num);
		i := i + 1;
		read_denom(base, i, denom);
		writeln(oper,' ', base,' ', num, ' ', denom);
		if oper = '+' then add_num(result, num, denom)
		else if oper = '-' then subtract_num(result, num, denom)
		else if oper = '*' then mult_num(result, num, denom)
		else divide_num(result, num, denom);
		i := 0;   
	end; 
	if ParamCount = 0 then
	begin
		writeln('mistake with base');
		exit;
	end
	else begin
		for i := 1 to ParamCount() do
		begin
			r := ParamStr(i);
			j := StrToInt(r);
			write_result(j, result);
		end;
	end;
	
	
end.
	
