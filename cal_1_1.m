clear;
close all;
syms A B C D E %A为city B为mountain C为fordable
syms equipment_cost install_fee depreciation_cost manufacturing_time ely_number
syms workforce_salaries salary_index recruit_fee manufacturing_time_fix
syms total_cost_A total_cost_B total_cost_C
syms A_time_fix B_time_fix C_time_fix
syms Global_index Quality_index
syms LA LB LC
syms earn_per_hour_A earn_per_hour_B earn_per_hour_C
syms unit_cost_A unit_cost_B unit_cost_C Fx Gx
syms contribution_margin_ratio_A contribution_margin_ratio_B contribution_margin_ratio_C
F=zeros(10,19);
G=zeros(10,10);
n=1;
t=1;
Global_index=1.3;
Quality_index=1.2;
salary_index=1.08;
for A=2000:50:6300                                             %四种车型循环
    for B=500:50:2100
        for C=4000:50:4500
            A_time_fix=12/Global_index;
            B_time_fix=18/Global_index;
            C_time_fix=12*Quality_index/Global_index;
            manufacturing_time=A_time_fix*A+B_time_fix*B+C_time_fix*C;                        %生产总时间
            manufacturing_time_fix=manufacturing_time;
            ely_number=ceil(manufacturing_time/1600);
            LA=A_time_fix*A/manufacturing_time_fix;
            LB=B_time_fix*B/manufacturing_time_fix;
            LC=C_time_fix*C/manufacturing_time_fix;                               %各产品加权系数
           if manufacturing_time_fix>72000                             %计算机器数量
                D=3;
                E=ceil((manufacturing_time_fix-72000)/(20*1600));
              elseif (manufacturing_time_fix>=48000) && (manufacturing_time_fix<=72000)
                D=3;
                E=0;
              elseif (manufacturing_time_fix>=24000) && (manufacturing_time_fix<=48000)
                D=2;
                E=0;
              elseif manufacturing_time_fix<=24000
                D=1;
                E=0;
           end
            if D==3                                                %计算安装成本
                install_fee=20000*E;
            else
                install_fee=20000*(3-D);
            end
            equipment_cost=20000*(D+E)+50000*(D+E)+install_fee;
            depreciation_cost=(D+E)*80000;
            if ceil(manufacturing_time_fix/1600)>45               %计算雇佣/裁员成本
                recruit_fee=0.1*(ceil(manufacturing_time_fix/1600)-45)*25000;
            else
                recruit_fee=0.3*(45-ceil(manufacturing_time_fix/1600))*25000;
            end
            workforce_salaries=ceil(manufacturing_time_fix/1600)*25000*salary_index+recruit_fee;
            total_cost_A=200*A+(equipment_cost+depreciation_cost+workforce_salaries)*LA;
            total_cost_B=200*B+(equipment_cost+depreciation_cost+workforce_salaries)*LB;
            total_cost_C=400*C+(equipment_cost+depreciation_cost+workforce_salaries)*LC;
            unit_cost_A=total_cost_A/A; % A车成本
            unit_cost_B=total_cost_B/B;
            unit_cost_C=total_cost_C/C;
            earn_per_hour_A=(820-unit_cost_A)/A_time_fix; %A车单位工时产出（标准售价）
            earn_per_hour_B=(920-unit_cost_B)/B_time_fix;
            earn_per_hour_C=(1600-unit_cost_C)/C_time_fix;
            contribution_margin_ratio_A=(820-unit_cost_A)/820;
            contribution_margin_ratio_B=(920-unit_cost_B)/920;
            contribution_margin_ratio_C=(1600-unit_cost_C)/1600;
            Fx=earn_per_hour_A*A*12+earn_per_hour_B*18*B+earn_per_hour_C*16*C;%总利润空间
            Gx=Fx/(A+B+C);                                                    %单件平均利润
            F(n,:)=[A B C ely_number manufacturing_time_fix unit_cost_A unit_cost_B unit_cost_C contribution_margin_ratio_A contribution_margin_ratio_B contribution_margin_ratio_C earn_per_hour_A earn_per_hour_B earn_per_hour_C Fx Gx D E n];
            n=n+1;
        end
    end
end
figure();hold on
min_markersize=5;max_markersize=25;
cur_markercoe=(F(:,15)-min(F(:,15)))/range(F(:,15));                          %按照百分制对该列求体积系数
cur_markersize1=cur_markercoe*(max_markersize-min_markersize)+min_markersize; %体积系数越大的利润越高，大体积为寻找的目标
norm_markersize=3;
critical_coe=0.7;
cur_markercoe1=(F(:,16)-min(F(:,16)))/range(F(:,16));                          %按照百分制对该列求体积系数
for e=1:length(cur_markercoe)    
    if (cur_markercoe(e)>=critical_coe) && (cur_markercoe1(e)>=critical_coe)
        G(t,1)=F(e,1);
        G(t,2)=F(e,2);
        G(t,3)=F(e,3);
        G(t,4)=F(e,4); 
        G(t,5)=F(e,5);
        G(t,6)=F(e,6); 
        G(t,7)=F(e,10);
        G(t,8)=F(e,11); 
        G(t,9)=F(e,12); 
        G(t,10)=F(e,13); 
        t=t+1;
    end
end
for j=1:length(cur_markercoe1)    
    if cur_markercoe(j)>=critical_coe
        plot3(F(j,1),F(j,2),F(j,3),'LineStyle','none','marker','.','MarkerSize',cur_markersize1(j),...
            'Color',color_map(0,1,cur_markercoe(j)));
    %else 
    %    plot3(F(j,1),F(j,2),F(j,3),'LineStyle','none','marker','.','MarkerSize',norm_markersize,...
     %       'Color',color_map(0,1,cur_markercoe(j)));
    end
end

