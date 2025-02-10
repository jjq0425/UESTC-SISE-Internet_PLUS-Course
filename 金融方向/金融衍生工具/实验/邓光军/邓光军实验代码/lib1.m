clear
mu=0.03;
dt=1/252;                         %·������������㡣
ts=0; 
rf=mu;                            %�޷�������
sg=0.6;                        %�ƽ�۸񲨶���
F=10000;                          %ծȯ��ֵ
SN=1000;                          %·������
for num=1:1:SN
    FT(num)=F*exp(-3*rf);        %��ֵ����
    gpath(num)=num;              %��¼��ǰ·���ı��
    randn('state',num*2+1);
    Gp(1)=200;                   %�ƽ��׼�۸�
    n=1;
    path(n)=1;
    for k=1:1:(252*3-1)         %ѭ��ֱ�����������ĩ
        path(n+1)=k+1;          %��¼��ǰ����ʱ���
        ran=randn(1);
        Gp(k+1)=Gp(k)+mu*Gp(k)*dt+sg*Gp(k)*ran*sqrt(dt);   
%�ƽ�۸����ɢģ��
% Gp(k+1)=Gp(k)*exp((mu-0.5*sg*sg)*dt+sg*ran*sqrt(dt))%�ƽ�۸������ģ��
        if k==252-1              %�����1�����
            FT(num)=FT(num)+0.035*F*exp(-rf);      %��������
        end
        if k==252*2-1             %�����2�����
            FT(num)=FT(num)+0.035*F*exp(-2*rf);     %��������
        end
        if k==252*3-1             %�����3�����
            if Gp(k+1)<=(1+0.035)*Gp(1)                     
 %���1���ƽ�۸��µ�������3.5%
                FT(num)=FT(num)+0.035*F*exp(-3*rf);  %��������
            end
            if (1+0.035)*Gp(1)<Gp(k+1)&Gp(k+1)<=(1+0.6)*Gp(1)
%���2���ƽ�۸���3.5%~60%�ķ�Χ������
FT(num)=FT(num)+0.035*F*exp(-3*rf)+0.3*(Gp(k+1)-(1+0.035)*Gp(1))*exp(-rf*3);								 %��������
            end
            if Gp(k+1)>(1+0.6)*Gp(1)                          
%���3���ƽ�۸����ǳ���60%     
FT(num)=FT(num)+0.035*F*exp(-3*rf)+0.3*((1+0.6)*Gp(1)-(1+0.035)*Gp(1))*exp(-rf*3);                                                    %��������
            end
        end
        n=n+1;
      end
      n
      k
      hold on
      plot(path,Gp,'k');            %���Ƶ�ǰ�ƽ�۸��·���仯����
end

xlabel('ʱ��');
ylabel('�ƽ�۸�');
figure
plot(gpath,FT,'xk');
title('ծȯ�۸�ֲ�');
xlabel('����·��');
ylabel('ծȯ��ֵ');
figure
xy=10130:.5:10160;
hist(FT,xy);
title('ծȯ��ֵƵ��ͼ');
ylabel('����');
xlabel('ծȯ��ֵ����');
GF=0;
% ��������ծȯ���ܼ�ֵ����ƽ�� %
for num=1:1:SN
    GF=GF+FT(num);
end
GF=GF/SN;                                   %ծȯ����ֵ
fprintf('ծȯ����ֵ��ƽ������ %f\n', GF);		%��ӡ���
clear
