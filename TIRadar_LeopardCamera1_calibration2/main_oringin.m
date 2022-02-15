%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%功能：实现联合标定
%输入：
% data:标定数据矩阵 N×5矩阵，N为样本数（不超过20），对于每个样本，前三个数表示雷达坐标[x,y,z]（float），后两个数表示对应的图像坐标点[xp,yp]（uint16）;
% A:内参矩阵 3×3矩阵（double float）
% B:外参矩阵 3×4矩阵（float）
%输出：
% H:坐标转移矩阵 3×4矩阵（double float）
%相关函数：
%psolution(alpha,fk,Jfk,Dk)：psolution(lambda,f,Jf,D)求p的最小二乘解
%dphi = dphisolution(lambda,f,Jf,D)：求dphi/dlambda
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%初始化
clear all;
close all;
% 外参矩阵求解参数
x=[sym('thetax');sym('thetay');sym('thetaz');sym('tx');sym('ty');sym('tz')]; %定义函数变量 x，共6个变量，x(1)~x(6)（double float）

% 外参初值的设置很关键，影响结果是否能正常收敛
xk=[0;0;0;0;0;0];

% 构建外参矩阵B
Rx=[1,0,0;0,cos(x(1)),sin(x(1));0,-sin(x(1)),cos(x(1))];
Ry=[cos(x(2)),0,-sin(x(2));0,1,0;sin(x(2)),0,cos(x(2))];
Rz=[cos(x(3)),-sin(x(3)),0;sin(x(3)),cos(x(3)),0;0,0,1];
B=[Rx*Ry*Rz,[x(4);x(5);x(6)]];
% 内参矩阵
A = [1984.70675623762,0,0;0,1985.52157573859,0;1462.83574464976,930.747160354737,1]'; % intrinsic matrix of LeopardCamera 2880x1860 oringin

%% 加载特征点
data_xyz=readmatrix("./data/OCULiiRadar_points.xlsx", "Range", [1 1]);
load ./runs_oringin/imagePoints.mat
data(:, 1:3)=data_xyz(:, 1:3);
save ./runs_oringin/allPoints data

%% 自动+手动剔除不好的点
data = data(data_xyz(:,4)==1,:);
data = data(sum(isnan(data),2)==0, :);
save ./runs_oringin/calibPoints data
%% 
N=size(data,1);%读取数据长度（uint8）
H=A*B;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%优化函数构造
f=[];
for i=1:N%样本优化函数构造
    % 不考虑畸变
    Z=H*[data(i,1);data(i,2);data(i,3);1];
    % 考虑畸变
    %Zc = B*[data(i,1);data(i,2);data(i,3);1];  
    
    
    f=[f;data(i,4)-Z(1)/Z(3);data(i,5)-Z(2)/Z(3)];    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%L-M算法部分，求解非线性优化问题，优化变量x。
Jf=jacobian(f);%计算函数雅可比矩阵（double float）
%初始化
xk_ini=xk;%优化变量赋初值（double float）
fk=double(subs(f,x,xk));%f函数赋值（double float）
Jfk=double(subs(Jf,x,xk));%Jf函数赋值（double float）
Dk=sqrt(diag(diag(Jfk'*Jfk)));%Dk赋初值（double float）
sigma=0.1;%sigma参数设置（float）
pk=1;%Pk赋初值（double float）
deltak=0.1;%步长赋初值（float）
i=0;%循环计数（uint16）
%loop
% while norm(pk)>0.1 %另一优化阈值 
while i<200 %以循环数作为优化阈值，优化阈值设置。
    i=i+1%循环计数 
    %step a,计算lambda：牛顿法权重参数
    Jfkpinv=pinv(Jfk);%求伪逆（double float）
    if norm(Dk*pinv(Jfk)*fk)<=(1+sigma)*deltak%判断下降梯度
        %梯度平稳，线性近似
        lambdak=0;%（double float）
        pk=-pinv(Jfk)*fk;%变化量pk（double float）
    else
        %梯度过陡，牛顿法拟合
        alpha=0;%lambda优化初值（double float）
        u=norm((Jfk*inv(Dk))'*fk)/deltak;%上确界计算（double float）
        palpha=psolution(alpha,fk,Jfk,Dk);%p_alpha计算(double float）
        qalpha=Dk*palpha;%q_alpha计算(double float）
        phi=norm(qalpha)-deltak;%phi计算(double float）
        dphi = dphisolution(alpha,fk,Jfk,Dk);%dphi/dlambda计算(double float）
        l=-phi/dphi;%下确界计算(double float）
        j=0;%循环初始化（uint16）
        while (abs(phi)>sigma*deltak)&&(j<100)%lambda优化循环
            j=j+1;%循环计数
            if alpha<=l||alpha>=u%判断是否超过取值范围
                alpha=(0.001*u>sqrt(l*u))*0.001*u+(0.001*u<=sqrt(l*u))*sqrt(l*u);%超过时对优化变量alpha进行调整
            end
            if phi<0%判断是否下降过少
                u=alpha;%上确界更新
            end
            l=l*(l>(alpha-phi/dphi))+(alpha-phi/dphi)*(l<=(alpha-phi/dphi));%下确界更新
            alpha=alpha-(phi+deltak)/deltak*phi/dphi;%alpha更新
            palpha=psolution(alpha,fk,Jfk,Dk);%p_alpha更新
            qalpha=Dk*palpha;%q_alpha更新
            phi=norm(qalpha)-deltak;%phi更新
            dphi=dphisolution(alpha,fk,Jfk,Dk);%dphi/dlambda更新
        end
        lambdak=alpha;%优化完成，lambda赋值
        pk = psolution(lambdak,fk,Jfk,Dk);%pk计算
    end
    %step b，步长评估，线性度计算
    fkp=double(subs(f,x,xk+pk));%变化后优化函数取值(double float）
    fkkp(:,i)=fkp'*fkp;
    rhok=((fk'*fk)-fkp'*fkp)/(fk'*fk-(fk+Jfk*pk)'*(fk+Jfk*pk)) ;%线性度计算(double float）
    %step c，优化变量更新
    if rhok>0.0001%线性度合适
        xk=xk+pk;%优化变量更新
        fk=double(subs(f,x,xk));%fk更新
        Jfk=double(subs(Jf,x,xk)); %Jfk更新
    end
    %step d，步长更新
    if rhok<=0.25%线性度过小，说明步长过大
        deltak=0.5*deltak;%步长缩小调整
    elseif (rhok>0.25&&rhok<0.75&&lambdak==0)||rhok>=0.75%线性度过大，说明步长过小
        deltak=2*norm(Dk*pk);%步长扩大调整
    end
    %step e，更新步长梯度
    Dk=(Dk>sqrt(diag(diag(Jfk'*Jfk)))).*Dk+(Dk<=sqrt(diag(diag(Jfk'*Jfk)))).*sqrt(diag(diag(Jfk'*Jfk)));%更新Dk
    xkk(:,i)=xk;%优化变量过程量存储，12×I矩阵，I为优化循环数（目前为1000）。
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%作图部分
xkk_ini=xk_ini*ones(1,size(xkk,2));%迭代精度计算中所用矩阵换算（12×I矩阵，double float）
y=diag(sqrt((xkk-xkk_ini)'*(xkk-xkk_ini)));%迭代精度计算，均方误差（double float）
plot(y)%成图
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%参数存储
Hx=double(subs(H,x,xk));%坐标转移矩阵（4×3矩阵，double float）
Bx=A\Hx;
save ./runs_oringin/Hx Hx;%坐标转移矩阵存储。（输出）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

