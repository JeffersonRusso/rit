package com.ritchie.formula;

import com.github.tomaslanger.chalk.Chalk;

import jmava.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class Formula {

    private final String inputText;
    private final boolean inputBoolean;
    private final String inputList;
    private final String inputPassword;

    public Formula(String inputText, boolean inputBoolean, String inputList, String inputPassword) {
        this.inputText = inputText;
        this.inputBoolean = inputBoolean;
        this.inputList = inputList;
        this.inputPassword = inputPassword;
    }

    public void Run() {

        ProcessBuilder processBuilder = new ProcessBuilder();
        processBuilder.command("G:/Program Files/Git/bin/bash.exe", "-c", "grep '^[PR_]' -i -r");

        Process process = null;
        try {
            process = processBuilder.start();
        } catch (IOException ex) {
            ex.printStackTrace();
        }
        StringBuilder output = new StringBuilder();
        BufferedReader reader = new BufferedReader(
                new InputStreamReader(process.getInputStream()));

        String line = null;
        while (true) {
            try {
                if (!((line = reader.readLine()) != null)) break;
            } catch (IOException ex) {
                ex.printStackTrace();
            }
            output.append(line + "\n");
        }
        int exitVal = 0;
        try {
            exitVal = process.waitFor();
        } catch (InterruptedException ex) {
            ex.printStackTrace();
        }
        if (exitVal == 0) {
            System.out.println(" --- Command run successfully\n");
            System.out.println(output);
        } else {
            System.out.println(" --- Command run unsuccessfully");
        }
    }
}
