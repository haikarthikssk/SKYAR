import java.applet.*;
import java.io.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
public class Joiner extends Applet implements ActionListener
{
	String data="";
	JButton jb;
	String Filename=null;
	public void paint(Graphics g)
	{
			super.paint(g);
			g.setColor(Color.BLUE);
			g.setFont(new Font("Calibri",32,32));
			g.drawString(data,250,250);
	}
	public void init()
	{
		jb=new JButton("Join");
		add(jb);
		jb.addActionListener(this);
	}
	public void actionPerformed(ActionEvent ae)
	{
		Frame parent=new Frame();
	JFileChooser fd=new JFileChooser();
	fd.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
	fd.showOpenDialog(null);
	if(fd.getSelectedFile()!=null)
	{
		Filename=JOptionPane.showInputDialog("Enter the Destination File name With Extension : ");
	}
	if(fd.getCurrentDirectory()!=null&&fd.getSelectedFile()!=null&&Filename!=null)
	{
		
		try
		{
			File f=new File(fd.getSelectedFile() + File.separator+"");
			File g[]=f.listFiles();
			File files[]=new File[g.length];
			int index=0;
			FileOutputStream fs=new FileOutputStream(fd.getSelectedFile() + File.separator+Filename);
			for(int j=0;j<g.length;j++)
			{
				if(g[j].toString().toUpperCase().endsWith(".KAR"))
				{
						for(int k=0;k<10;k++)
						{
							if(g[j].getName().toUpperCase().equals(k+".KAR"))
							{
									data="Writing "+g[j].getName()+" to file";
									repaint();
									FileInputStream in=new FileInputStream(g[j]);
									int count=0;
									byte[] data=new byte[1024];
									while((count=in.read(data,0,1024))!=-1)							
									{
											fs.write(data,0,count);
									}
									in.close();
						}
				}
			}
			data="Write Complete";
			repaint();
		}
			fs.close();

		}
		catch(Exception e)
		{
				data=e.getMessage();
				repaint();
		}
	}
	}
}