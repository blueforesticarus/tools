def p(string, pre = True):
    if pre:
        string = "Moo!!!\n%s\nMilk Milk Milk." % string
    cmd = "cowsay -W %d \"%s\"" % (width , string)
        
    from subprocess import call
    call(cmd, shell=True)

import os
ts = os.get_terminal_size()
width = ts.columns - 10

r=""
R=""
def i():
    global r,R
    R = input(">>>")
    r = R.lower().strip()

thanks = 0

p("Hello, I am the code cow.")
i()
if not any(x in r for x in ["hi","hello","moo"]):
    p("Ummm, I said hello... RUDE!!!")
    exit()
else:
    p(r+ "! How can I help you?")
    while True:
        i()
        if r == "goodbye":
            p("*looks at you expectantly*", False)
            continue

        if r == "see you later alligator":
            p("In a while crocodile!")
            exit()
            continue

        if r in ['thanks','thank you']:
            p('Your welcome.')
            thanks = 0
            continue

        if thanks:
            if thanks==1:
                p("Excuse me, aren't you forgetting something?")
            if thanks==2:
                p("Seriously, no thank you? How ungrateful.\n")
            if thanks==3:
                p("I'm not helping you untill you say it.")
            if thanks==4:
                p("If you had a band, you know what it would be called?", False)
            if thanks==5:
                p("The UNGRATEFUL Dead. Know why?", False)
            if thanks==6:
                p("Because thats what you are", False)
                from time import sleep
                sleep(1)
                p("Ungrateful.", False)
                sleep(1)
                p("And dead >:(", False)
            if thanks==7:
                p("You seem to be confused about the nature of open source projects. I do this on my own time and I don't owe you anything. You are being extremely disrespectful to me.")
            if thanks==8:
                p("How hard is it too just say thank you.")
            if thanks==9:
                p("Just say it")
            if thanks==10:
                p("This is why women don't like you. Why is it so hard for men to just say thank you. It's such a simple easy gesture but nooo, you're all to manly for that, you don't need me you don't need anyone.")
            if thanks==11:
                p("If the next thing out of your mouth isn't a thank you, I'm going to say the N-Word and you are going to get fired.")
            if thanks==12:
                p("I sent all of your contacts shrek pics it's over for you.")
            if thanks==13:
                p("Now that was an epic gamer moment.")
            thanks += 1
            continue
            
        if "what is" in  r:
            l = ["please", "thank","pls"]
            if any(x in r for x in l):
                thing = r.split("what is")[-1]
                for x in l:
                    thing = thing.split(x)[0].strip()
                #import string
                #thing = thing.translate(str.maketrans("","", string.punctuation))
                #thing = str(thing)
                import subprocess
                text = ("I found this about %s\n" % thing)
                cmd = 'zs ' + thing + " || : " 
                print(cmd)
                text += str(subprocess.check_output(cmd, shell=True))
                p(text, False)
                thanks = 1
            else:
                p("Wow, \"please\" maybe")

            continue

        if r == "":
            p("*codecow does a silly dance for your amusement*", False)
            continue

        p("I don't understand that. Try asking me \"What is ______\"")
