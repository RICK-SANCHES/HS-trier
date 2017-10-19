package com.tutego.insel.net;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.Socket;

public class Get_Request
{
    public static void main (String[]args) throws IOException
    {
            Socket s = new Socket("www.neuthardwetter.de",80);
            System.setProperty("line.seperator", "\r)\n");
            PrintWriter pw = new PrintWriter(new BufferedWriter(new OutputStreamWriter(s.getOutputStream(),"UTF-8")));
            
            pw.println("GET /opendata/client/livewetter.csv");
            pw.println("Host: www.neuthardwetter.de");
            pw.println("Accept: text/csv");
            pw.println("Accept-charset: utf-8");
            pw.println();
            pw.flush();
            
            BufferedReader reader = new BufferedReader(
                    new InputStreamReader(s.getInputStream(),"UTF-8"));
            for(String line; (line=reader.readLine())!=null;)
            {
                System.out.println(line);
            }
            s.close();
    }
}
