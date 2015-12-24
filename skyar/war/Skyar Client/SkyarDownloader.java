import java.applet.*;
import java.io.*;
import java.net.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
public class SkyarDownloader extends Applet implements ActionListener
{
	JLabel STATUS;
	JButton BUTTON_DOWNLOAD;
	JTextField TEXT_AREA;
	String URLTODOWNLOAD="URL";
	long START,END;
	String FILENAME="";
	int NOF=0;
	boolean skip=true;
	String KEY="";
	public static JProgressBar jp;
	public static JButton PAUSE;
	public void init()
	{

		//JPanel WINDOW=new JPanel();
		TEXT_AREA =new JTextField(getParameter("URLTODOWNLOAD"));
		add(TEXT_AREA);
		try
		{
		TEXT_AREA.setText(URLTODOWNLOAD);
	}
	catch(Exception e)
	{
		System.out.println(e.getMessage());
	}
	try
	{
		BUTTON_DOWNLOAD=new JButton("Download File");
		add(BUTTON_DOWNLOAD);
		PAUSE=new JButton("Pause");
		add(PAUSE);
		PAUSE.setEnabled(false);
		STATUS=new JLabel("Status!!");
		add(STATUS);
		BUTTON_DOWNLOAD.addActionListener(this);
		PAUSE.addActionListener(this);
		jp=new JProgressBar();
		jp.setStringPainted(true);
		add(jp);
			URLTODOWNLOAD=getParameter("URLTODOWNLOAD");
			START=new Long(getParameter("START"));
			END=new Long(getParameter("END"));
			if(END<0)
			{
				NOF=Integer.parseInt(getParameter("NOF"));
			}
			FILENAME=getParameter("SEGMENT");
			KEY=getParameter("key");
			TEXT_AREA.setText(getParameter("URLTODOWNLOAD"));
			TEXT_AREA.setEnabled(false);
		}
		catch(Exception e)
		{
			System.out.println(e.getMessage());
		}

javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addContainerGap(51, Short.MAX_VALUE)
                .addComponent(TEXT_AREA, javax.swing.GroupLayout.PREFERRED_SIZE, 155, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addComponent(BUTTON_DOWNLOAD)
                .addGap(18, 18, 18)
                .addComponent(PAUSE)
                .addGap(144, 144, 144))
            .addGroup(layout.createSequentialGroup()
                .addGap(640, 640, 640)
                .addComponent(STATUS)
                .addContainerGap())
            .addComponent(jp, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGap(85, 85, 85)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(TEXT_AREA, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(BUTTON_DOWNLOAD)
                    .addComponent(PAUSE))
                .addGap(18, 18, 18)
                .addComponent(jp, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(46, 46, 46)
                .addComponent(STATUS)
                .addContainerGap(195, Short.MAX_VALUE))
        );





	}
	public void paint(Graphics g)
	{
			super.paint(g);
			g.drawString("URL : "+URLTODOWNLOAD,50,50);
			g.drawString("Size : "+((END-START)/1024/1024)+" MB",50,70);
			g.drawString("Key : "+KEY,50,90);
	}
	void calculateStartEnd()
	{
		Long Size=0L;
		int segmentid=Integer.parseInt(FILENAME);
		Long SX=0L,EX=0L;
		try
		{
		URL host = new URL(URLTODOWNLOAD);
        HttpURLConnection yc =(HttpURLConnection) host.openConnection();
        BufferedReader br=new BufferedReader(new InputStreamReader(yc.getInputStream()));
		Size=new Long(yc.getContentLength());
		skip=br.markSupported();
		br.close();
		if(Size<0)
		{
			END=-1;
		}
		else
		{
		int k=NOF;
				Long sindex=Size/k;
				Long index=0L,cache=0L;
				int temp=0;
				while(index<=Size)
				{
					if(index>0)
					{
					
					if(temp==segmentid+1)
					{
					if(index+sindex>Size)
					{
					SX=cache;
					EX=Size;
					}
					else
					{
					SX=cache;
					EX=index;
					}
					break;
					}
					}
					cache=index;
					temp++;
					index+=sindex;
				}
				START=SX;
				END=EX;
		}
		}
		catch(Exception e)
		{
			System.out.println(e.getMessage());
		}
	}
	public void actionPerformed(ActionEvent ae)
	{
		if(ae.getSource()==BUTTON_DOWNLOAD){
			if(!skip)
			{
				STATUS.setText("Resume Option Not Supported By the Server...");
				repaint();
			}
			else if(END<0)
			{
				STATUS.setText("Please Wait!! Calculating File Size...");
				calculateStartEnd();
				repaint();
			}
			if(END>0)
			{
		Downloaderx tr= new Downloaderx(TEXT_AREA.getText(),STATUS,START,END,FILENAME,KEY);
		tr.start();
		}
		else
		{
			STATUS.setText("Can't Determine the File Length!!");
		}
		}
		else if(ae.getSource()==PAUSE)
		{
			
			
			if(PAUSE.getText().equals("Resume"))
			{
				PAUSE.setText("Pause");
				STATUS.setText("Downloading!!");
				Downloaderx.status=true;
				Updater.reportStatus(KEY,"2");
			}
			else
			{
					PAUSE.setText("Resume");
					STATUS.setText("Download Paused!!");
					Downloaderx.status=false;
					Updater.reportStatus(KEY,"3");

			}

		}
	}
	public void setStatus(String Text)
	{
			STATUS.setText(Text);
	}
}
class Downloaderx extends Thread {
	String URL_TO_DOWLOAD;
	JLabel LABEL;
	long startbit,endbit;
	String FILENAME;
	static boolean status=true;
	String key;
	public Downloaderx(String x,JLabel y,long start,long end,String filename,String Key)
	{
		URL_TO_DOWLOAD=x;
		LABEL=y;
		startbit=start;
		endbit=end;
		FILENAME=filename;
		key=Key;
	}
public void run(){
	LABEL.setText("Choose a File");
	Frame parent=new Frame();
	JFileChooser fd=new JFileChooser();
	
	fd.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
	fd.showOpenDialog(null);
	if(fd.getCurrentDirectory()!=null&&fd.getSelectedFile()!=null)
	{
		try
		{
				Updater upx=new Updater();
				Thread x=new Thread(upx);
				x.start();
				SkyarDownloader.PAUSE.setEnabled(true);

				URL url=new URL(URL_TO_DOWLOAD);
				HttpURLConnection connection = (HttpURLConnection) url.openConnection();
				connection.setRequestProperty("Range", "bytes="+startbit+"-");
				connection.setDoInput(true);
    			connection.setDoOutput(true);
				BufferedInputStream in=new BufferedInputStream(connection.getInputStream());
				
					FileOutputStream fot=new FileOutputStream(new File( fd.getSelectedFile() + File.separator + FILENAME+".KAR"));
				//	in.skip(startbit);
					byte data[]=new byte[1024];
					int count;
					Long ccount=startbit;
					LABEL.setText("Starting Download!!");
					Updater.reportStatus(key,"2");
					while((count=in.read(data,0,1024))!=-1)
					{
						while(!status)
					{
							Thread.sleep(500);
							
					}
				//Thread.sleep(10);
						ccount+=count;
						if(ccount>=endbit)
						{
							
							fot.write(data,0,count-(int)(ccount-endbit));
							upx.setData(100);
							SkyarDownloader.PAUSE.setEnabled(false);
							break;
						}
						fot.write(data,0,count);
						
						//upx.setData((int)((float)((float)(ccount)/(float)(endbit))*100)+" %");
						upx.setData((int)((float)((float)(ccount)/(float)(endbit))*100));
						//Thread.sleep(1000);
					}
					in.close();
					fot.close();
					LABEL.setText("Download Finished!!");
					Updater.reportStatus(key,"4");
		}
		catch(Exception e)
		{
			System.out.println(e.getMessage());
			Updater.reportStatus(key,"5");
			LABEL.setText(e.getMessage());
			e.printStackTrace();
		}
	}
}
}
class Updater extends Thread
{
	int Data=0;
	public void setData(int data)
	{
		Data=data;
	}
	public void run()
	{
		while(true)
		{
		try
		{
			SkyarDownloader.jp.setValue(Data);
			SkyarDownloader.jp.setString(Data+"%");
			Thread.sleep(1000);
		}
		catch(Exception e)
		{

		}
	}
	}
	public static void reportStatus(String key,String data)
	{
		try
		{
		URL ux=new URL("http://gcdc2013-skyar.appspot.com/setData.jsp?Action=DStatus&Key="+key+"&Status="+data); //replace with your url
        URLConnection cy = ux.openConnection();
        BufferedReader ins = new BufferedReader(new InputStreamReader(cy.getInputStream()));
        ins.readLine();
        ins.close();
        ins=null;
        ux=null;
    	}
    	catch(Exception e)
    	{
    			System.out.println(e.getMessage());
    	}

	}
}