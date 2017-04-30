    function Yesti = ventanaParzen(Xval,Xent,Yent,h,tipo)

      %%% La función debe retornar el valor de predicción Yesti para cada una de 
	  %%% las muestras en Xval. Por esa razón Yesti se inicializa como un vectores 
	  %%% de ceros, de dimensión M.
  
      M=size(Xval,1);
      N=size(Xent,1);
      dis=zeros(N,1);
      Yesti=zeros(M,1);
      
      if strcmp(tipo,'regress')
          for j=1:M
              %%% Complete el codigo %%%
              for i = 1:N
                  dis(i) = sqrt(sum(((Xval(j,:) - Xent(i, :)).^ 2), 2));
              end
              kernel=gaussianKernel(dis/h);
              Yesti(j) = (kernel'*Yent)/sum(kernel);
              %%%%%%%%%%%%%%%%%%%%%%%%%%
          end
      elseif strcmp(tipo,'class')
          for j=1:M
              %%% Complete el codigo %%%
              for i = 1:N
                  dis(i) = sqrt(sum(((Xval(j,:) - Xent(i, :)).^ 2), 2));
              end
              kernel=gaussianKernel(dis/h);
              Yesti(j) = (sum(kernel))/N;
              %%%%%%%%%%%%%%%%%%%%%%%%%%
          end
      end
    end