WMIを使って電波強度を取得 - まめ畑
https://conmame.hatenablog.com/entry/20080217/1203174782

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Management;
using System.Collections;

namespace WaveStrengthGui
{
    public partial class Form1 : Form
    {
        private Hashtable tempHash = new Hashtable(20);

        public Form1()
        {
            InitializeComponent();
            timer1.Start();
        }

        private void doCheck()
        {
            int i = 0;
            int maxStrengthIndex = 0;
            string ssidString = null;
            try
            {
		//WMIから電波強度を取得
                ManagementObjectSearcher sercher = new ManagementObjectSearcher(@"root\WMI", "SELECT * FROM MSNdis_80211_ReceivedSignalStrength");
                ManagementObjectCollection collection = sercher.Get();

                foreach (ManagementObject mo in collection)
                {
                    tempHash[i] = Convert.ToDouble(mo.GetPropertyValue("Ndis80211ReceivedSignalStrength"));
                }

		//最大電波強度を取得
                maxStrengthIndex = getMaxStrength(tempHash);

		//SSIDをWMIから取得
                ManagementClass mc = new ManagementClass("root\\WMI", "MSNdis_80211_ServiceSetIdentifier", null);
                ManagementObjectCollection collection2 = mc.GetInstances();

                foreach (ManagementObject mo in collection2)
                {
                    byte[] ssid = (byte[])mo["Ndis80211SsId"];
                    ssidString = Encoding.ASCII.GetString(ssid).Substring(4);
                }

                label5.Text = ssidString;
                label1.Text = Convert.ToString(tempHash[maxStrengthIndex]);
                Application.DoEvents();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "エラー", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private int getMaxStrength(Hashtable hs)
        {
            double tempMax = 0.0;
            int maxIndex = 0;

            foreach (int i in hs.Keys)
            {
                if (tempMax < (double)hs[i])
                {
                    maxIndex = i;
                    tempMax = (double)hs[i];
                }
            }
            return maxIndex;
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            this.doCheck();
        }

        private void Form1_FormClosing(object sender, FormClosingEventArgs e)
        {
            timer1.Stop();
        }
    }
}
