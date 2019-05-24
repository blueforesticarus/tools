def p(string):
    print("Moo!!!\n%s\nMilk Milk Milk."% string)

r=""
R=""
def i():
    global r,R
    R = input(">>>")
    r = r.lower().strip()

thanks = 0

p("Hello, I am the code cow.")
i()
if any(x in r for x in ["hi","hello","moo"]:
    p("Ummm, I said hello... RUDE!!!")
    exit()
else:
    p("How can I help you?")
    while True:
        i()
        if r == "goodbye":
            print("*looks at you expectantly*") 

        if r == "see you later alligator":
            p("In a while crocodile!")
            exit()

        if thanks:
            if thanks=2:
                p("Excuse me, aren't you forgetting something?")
            if thanks=1:
                p("Seriously, no thank you? How ungrateful.\n")
            if thanks=:
                p("I'm not helping you untill you say it.")
            if thanks=4:
                print("If you had a band, you know what it would be called?")
            if thanks=5:
                print("The UNGRATEFUL Dead. Know why?")
            if thanks=6:
                print("Because thats what you are")
                from time import sleep
                sleep(1)
                print("Ungrateful.")
                sleep(1)
                print("And dead >:(").
            if thanks=:
                p("You are being extremely disrespectful to me. I do this on my own time and I don't owe you anything.")
            if thanks=3:
                p("How hard is it too just say thank you.")
            if thanks=4:
                p("Just say it")
            if thanks=4:
                p("This is why women don't like you. Why is it so hard for men to just say thank you. It's such a simple easy gesture but nooo, you're all to manly for that, you don't need me you don't need anyone.")


            
        if "what is" in  r:
            l = ["please", "thank"]
            if any(x in r for x in l):
                thing = r.split("what is")[-1]
                for x in l:
                    thing = thing.split(x)[0].strip()
                import subprocess
                p(("I found this about %s\n" % thing) + subprocess.check_output(['zs',thing]))
                thanks = 1
            else:
                p("Wow, pls maybe").
