%Sección 1 - Solicitar al usuario que ingrese un número Positivo
n = input('Ingrese un número entero positivo: ');
%Sección 2 - Verificar si el número es positivo
try
  if n < 0
    error('El factorial no está definido para número negativos.');
  elseif n == 0 || n == 1
    factorial = 1;
  else
    factorial = 1;
    for i = 2:n
      factorial = factorial *i;
    end
   end
   fprintf('El factorial de %d es %d\n', n, factorial);
catch e
   fprintf('Error: %s\n', e.message);
end

