clear
mu=0.03;
dt=1/252;                         %路径间隔，以天算。
ts=0; 
rf=mu;                            %无风险利率
sg=0.6;                        %黄金价格波动率
F=10000;                          %债券面值
SN=1000;                          %路径个数
for num=1:1:SN
    FT(num)=F*exp(-3*rf);        %面值贴现
    gpath(num)=num;              %记录当前路径的编号
    randn('state',num*2+1);
    Gp(1)=200;                   %黄金基准价格
    n=1;
    path(n)=1;
    for k=1:1:(252*3-1)         %循环直到到达第三年末
        path(n+1)=k+1;          %记录当前所在时间点
        ran=randn(1);
        Gp(k+1)=Gp(k)+mu*Gp(k)*dt+sg*Gp(k)*ran*sqrt(dt);   
%黄金价格的离散模型
% Gp(k+1)=Gp(k)*exp((mu-0.5*sg*sg)*dt+sg*ran*sqrt(dt))%黄金价格的连续模型
        if k==252-1              %到达第1年年底
            FT(num)=FT(num)+0.035*F*exp(-rf);      %计算收益
        end
        if k==252*2-1             %到达第2年年底
            FT(num)=FT(num)+0.035*F*exp(-2*rf);     %计算收益
        end
        if k==252*3-1             %到达第3年年底
            if Gp(k+1)<=(1+0.035)*Gp(1)                     
 %情况1：黄金价格下跌不超过3.5%
                FT(num)=FT(num)+0.035*F*exp(-3*rf);  %计算收益
            end
            if (1+0.035)*Gp(1)<Gp(k+1)&Gp(k+1)<=(1+0.6)*Gp(1)
%情况2：黄金价格在3.5%~60%的范围内上涨
FT(num)=FT(num)+0.035*F*exp(-3*rf)+0.3*(Gp(k+1)-(1+0.035)*Gp(1))*exp(-rf*3);								 %计算收益
            end
            if Gp(k+1)>(1+0.6)*Gp(1)                          
%情况3：黄金价格上涨超过60%     
FT(num)=FT(num)+0.035*F*exp(-3*rf)+0.3*((1+0.6)*Gp(1)-(1+0.035)*Gp(1))*exp(-rf*3);                                                    %计算收益
            end
        end
        n=n+1;
      end
      n
      k
      hold on
      plot(path,Gp,'k');            %绘制当前黄金价格的路径变化曲线
end

xlabel('时间');
ylabel('黄金价格');
figure
plot(gpath,FT,'xk');
title('债券价格分布');
xlabel('样本路径');
ylabel('债券价值');
figure
xy=10130:.5:10160;
hist(FT,xy);
title('债券价值频率图');
ylabel('个数');
xlabel('债券价值区间');
GF=0;
% 叠加所有债券可能价值，求平均 %
for num=1:1:SN
    GF=GF+FT(num);
end
GF=GF/SN;                                   %债券最后价值
fprintf('债券最后价值（平均）： %f\n', GF);		%打印输出
clear
