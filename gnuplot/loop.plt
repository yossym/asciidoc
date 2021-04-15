if (exist("n")==0 || n<0) n=0 #�ϐ��̏�����

set samples 1000
set xrange [0:2*pi]
set yrange [-1:1]
plot cos(2*x-2.0*n*pi/30.0)*exp(-0.4*x) title sprintf("n = %d", n)

if (n<200) pause 0.1; n=n+1; \
          reread        # �X�N���v�g�̍ēǂݍ���

n=-1
#end of script
