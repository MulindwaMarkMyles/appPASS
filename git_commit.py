import os, time

count:int = 1

while(True):
    os.system("git add .")
    time.sleep(10)
    os.system("git commit -m \"homepage\" ")
    time.sleep(10)
    os.system("git push origin mulindwa")
    print(f"Done pushing - {count}")
    time.sleep(60)
    count += 1