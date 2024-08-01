import os, time

count:int = 1

while(True):
    os.system("git add .")
    time.sleep(10)
    os.system("git commit -m \"decryption\" ")
    time.sleep(10)
    os.system("git push origin mulindwa")
    print(f"Done pushing - {count}")
    time.sleep(150)
    count += 1