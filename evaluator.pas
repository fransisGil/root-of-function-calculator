unit evaluator;

interface

uses
  System.SysUtils, System.Math, System.Character;

function EvaluateExpression(const Expr: string; X: Double): Double;

implementation

// Konversi string ke double dengan pemisah desimal titik (.)
function StringToDoubleLocale(const S: string): Double;
var
  s2: string;
  code: Integer;
begin
  s2 := Trim(S);
  s2 := StringReplace(s2, ',', '.', [rfReplaceAll]);
  Val(s2, Result, code);
  if code <> 0 then
    raise Exception.CreateFmt('Angka tidak valid: %s', [S]);
end;

type
  TTokenType = (ttNumber, ttVariable, ttOperator, ttFunction, ttLeftParen, ttRightParen, ttComma, ttEnd);

  TToken = record
    TokenType: TTokenType;
    Value: string;
    Number: Double;
  end;

  TTokenizer = class
  private
    FExpr: string;
    FPos: Integer;
    function CurrentChar: Char;
    procedure NextChar;
    procedure SkipWhitespace;
  public
    constructor Create(const AExpr: string);
    function GetNextToken: TToken;
  end;

  TParser = class
  private
    FTokenizer: TTokenizer;
    FCurrentToken: TToken;
    FX: Double;
    procedure NextToken;
    function ParseExpression: Double;
    function ParseTerm: Double;
    function ParseFactor: Double;
    function ParsePower: Double;
    function ParsePrimary: Double;
    function ParseFunction(const FuncName: string; Arg: Double): Double;
  public
    constructor Create(const AExpr: string; X: Double);
    function Evaluate: Double;
  end;

{ TTokenizer }

constructor TTokenizer.Create(const AExpr: string);
begin
  FExpr := AExpr;
  FPos := 1;
end;

function TTokenizer.CurrentChar: Char;
begin
  if FPos <= Length(FExpr) then
    Result := FExpr[FPos]
  else
    Result := #0;
end;

procedure TTokenizer.NextChar;
begin
  Inc(FPos);
end;

procedure TTokenizer.SkipWhitespace;
begin
  while (FPos <= Length(FExpr)) and (CurrentChar = ' ') do
    NextChar;
end;

function TTokenizer.GetNextToken: TToken;
var
  ch: Char;
  startPos: Integer;
  temp: string;
begin
  SkipWhitespace;
  ch := CurrentChar;
  if ch = #0 then
  begin
    Result.TokenType := ttEnd;
    Exit;
  end;

  if CharInSet(ch, ['0'..'9', '.']) then
  begin
    startPos := FPos;
    while CharInSet(CurrentChar, ['0'..'9', '.']) do
      NextChar;
    temp := Copy(FExpr, startPos, FPos - startPos);
    Result.TokenType := ttNumber;
    Result.Value := temp;
    Result.Number := StringToDoubleLocale(temp);
    Exit;
  end;

  if CharInSet(ch, ['x','X']) then
  begin
    NextChar;
    Result.TokenType := ttVariable;
    Result.Value := 'x';
    Exit;
  end;

  if CharInSet(ch, ['+', '-', '*', '/', '^']) then
  begin
    NextChar;
    Result.TokenType := ttOperator;
    Result.Value := ch;
    Exit;
  end;

  if ch = '(' then
  begin
    NextChar;
    Result.TokenType := ttLeftParen;
    Exit;
  end;

  if ch = ')' then
  begin
    NextChar;
    Result.TokenType := ttRightParen;
    Exit;
  end;

  if ch = ',' then
  begin
    NextChar;
    Result.TokenType := ttComma;
    Exit;
  end;

  if CharInSet(ch, ['a'..'z', 'A'..'Z']) then
  begin
    startPos := FPos;
    while CharInSet(CurrentChar, ['a'..'z', 'A'..'Z']) do
      NextChar;
    temp := LowerCase(Copy(FExpr, startPos, FPos - startPos));
    Result.TokenType := ttFunction;
    Result.Value := temp;
    Exit;
  end;

  raise Exception.Create('Karakter tidak dikenal: ' + ch);
end;

{ TParser }

constructor TParser.Create(const AExpr: string; X: Double);
begin
  FTokenizer := TTokenizer.Create(AExpr);
  FX := X;
  NextToken;
end;

procedure TParser.NextToken;
begin
  FCurrentToken := FTokenizer.GetNextToken;
end;

function TParser.ParseExpression: Double;
var
  left: Double;
  op: string;
begin
  left := ParseTerm;

  while (FCurrentToken.TokenType = ttOperator) and
        ((FCurrentToken.Value = '+') or
         (FCurrentToken.Value = '-')) do
  begin
    op := FCurrentToken.Value;
    NextToken;

    if op = '+' then
      left := left + ParseTerm
    else
      left := left - ParseTerm;
  end;

  Result := left;
end;

function TParser.ParseTerm: Double;
var
  left: Double;
  op: string;
begin
  left := ParseFactor;

  while (FCurrentToken.TokenType = ttOperator) and
        ((FCurrentToken.Value = '*') or
         (FCurrentToken.Value = '/')) do
  begin
    op := FCurrentToken.Value;
    NextToken;

    if op = '*' then
      left := left * ParseFactor
    else
      left := left / ParseFactor;
  end;

  Result := left;
end;

function TParser.ParseFactor: Double;
begin
  if (FCurrentToken.TokenType = ttOperator) then
  begin
    if FCurrentToken.Value = '+' then
    begin
      NextToken;
      Result := ParseFactor;
      Exit;
    end;

    if FCurrentToken.Value = '-' then
    begin
      NextToken;
      Result := -ParseFactor;
      Exit;
    end;
  end;

  Result := ParsePower;
end;

function TParser.ParsePower: Double;
var
  left: Double;
begin
  left := ParsePrimary;

  if (FCurrentToken.TokenType = ttOperator)
     and (FCurrentToken.Value = '^') then
  begin
    NextToken;

    Result := Power(left, ParsePower);
  end
  else
    Result := left;
end;

function TParser.ParsePrimary: Double;
var
  token: TToken;
  funcName: string;
  arg: Double;
begin
  token := FCurrentToken;

  case token.TokenType of

    ttNumber:
      begin
        NextToken;
        Result := token.Number;
        if (token.TokenType = ttFunction) and (token.Value = 'e') then
        begin
          NextToken;
          Result := Exp(1);
          Exit;
        end;

        if (token.TokenType = ttFunction) and (token.Value = 'pi') then
        begin
          NextToken;
          Result := Pi;
          Exit;
        end;
      end;



    ttVariable:
      begin
        NextToken;
        Result := FX;
      end;

    ttFunction:
      begin
        funcName := token.Value;

        NextToken;

        if FCurrentToken.TokenType <> ttLeftParen then
          raise Exception.Create('Expected ( after function');

        NextToken;

        arg := ParseExpression;

        if FCurrentToken.TokenType <> ttRightParen then
          raise Exception.Create('Expected ) after function arguments');

        NextToken;

        Result := ParseFunction(funcName, arg);
      end;

    ttLeftParen:
      begin
        NextToken;

        Result := ParseExpression;

        if FCurrentToken.TokenType <> ttRightParen then
          raise Exception.Create('Missing closing parenthesis');

        NextToken;
      end;

  else
    raise Exception.Create('Unexpected token');
  end;
end;

function TParser.ParseFunction(const FuncName: string; Arg: Double): Double;
begin
  if FuncName = 'sin' then
    Result := Sin(Arg)

  else if FuncName = 'cos' then
    Result := Cos(Arg)

  else if FuncName = 'tan' then
    Result := Tan(Arg)

  else if FuncName = 'exp' then
    Result := Exp(Arg)

  else if FuncName = 'ln' then
    Result := Ln(Arg)

  else if FuncName = 'sqrt' then
    Result := Sqrt(Arg)

  else if FuncName = 'abs' then
    Result := Abs(Arg)

  else
    raise Exception.Create('Fungsi tidak dikenal: ' + FuncName);
end;

function TParser.Evaluate: Double;
begin
  Result := ParseExpression;
  if FCurrentToken.TokenType <> ttEnd then
    raise Exception.Create('Extra characters at end of expression');
end;

function EvaluateExpression(const Expr: string; X: Double): Double;
var
  parser: TParser;
begin
  parser := TParser.Create(Expr, X);
  try
    Result := parser.Evaluate;
  finally
    parser.Free;
  end;
end;

end.
