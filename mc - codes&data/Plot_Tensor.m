load EnergiaVsPassi_Tinf_Repulsivo.txt

clc

Matrix = EnergiaVsPassi_Tinf_Repulsivo;

Tensor = zeros(100,5);

for i = 1:100

    for j = 1:5

        Tensor(i,j) = Matrix(i+100*(j-1),2);
                
    end
end

ribbon(Tensor);


for i=1:100
    
    vector(i) = Tensor(i,3);
    
end

plot(1:100,vector)

axis square