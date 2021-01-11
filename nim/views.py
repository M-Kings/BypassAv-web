from django.views.decorators.http import require_GET, require_POST
from django.core.files import File
from django import forms
from django.shortcuts import render,HttpResponseRedirect,HttpResponse
import os,re,hashlib,random,time

SAVED_FILES_DIR = r'files/'

def render_home_template(request):
    files = os.listdir(SAVED_FILES_DIR)
    return render(request, 'home.html')

def filesha256():
    complex_str = "fs75@5fd%5386v^&#scs494**-cs/56/_ss$$DSD125c!#|FR54545dsdsc"
    string_list = []

    for i in range(15):
        string_list.append(random.choice(complex_str))

    salt = ''.join(string_list)
    #print(salt)  # 打印显示的随机字符

    hash_str = hashlib.md5()
    hash_str.update(salt.encode())
    filesha256 = hash_str.hexdigest()
    #print(filesha256)
    return str(filesha256)

class SelectTestForm(forms.Form):
    SELVALUE = (
        ('i386', 'i386'),
        ('amd64', 'amd64'),
    )
    sel_value = forms.CharField(max_length=10,widget=forms.widgets.Select(choices=SELVALUE))

@require_GET
def home(request):
    files = os.listdir(SAVED_FILES_DIR)
    #if not os.path.exists(SAVED_FILES_DIR):
    #    os.makedirs(SAVED_FILES_DIR)
    select_form = SelectTestForm()
    return render(request,"home.html",{'select_form': select_form,})


@require_GET
def download(request, filename):
    file_pathname = os.path.join(SAVED_FILES_DIR, filename)

    with open(file_pathname, 'rb') as f:
        file = File(f)

        response = HttpResponse(file.chunks(),
                                content_type='APPLICATION/OCTET-STREAM')
        response['Content-Disposition'] = 'attachment; filename=' + filename
        response['Content-Length'] = os.path.getsize(file_pathname)
    os.remove(file_pathname)
    return response

def codetoexe(code,type):
    complex_str = "qwertyuiopasdfghjklzxcvbnm"
    string_list = []

    for i in range(5):
        string_list.append(random.choice(complex_str))

    codefilename = ''.join(string_list)
    codefile = open('./temp/'+codefilename+".nim",mode='w+',encoding="utf8")
    codefile.write(code)
    codefile.close()
    ##codetoexe = os.system('nim c -d=mingw --app=console --cpu=amd64 .\\temp\\'+codefilename+' --outdir .\\files\\ -o '+codefilename+'.exe')
    if type == 'i386':
        codeing = 'nim c -d=mingw --app=console --cpu=i386 -o=./files/'+codefilename+'.exe'+' ./temp/'+codefilename+'.nim'
    elif type == 'amd64':
        codeing = 'nim c -d=mingw --app=console --cpu=amd64 -o=./files/'+codefilename+'.exe'+' ./temp/'+codefilename+'.nim'
    #print(codeing)
    time.sleep(1)
    os.system(codeing)
    os.remove('./temp/' + codefilename + ".nim")
    return codefilename+'.exe'

def shellcodexor(shellcode):
    yesxor = os.popen('/root/FileService/code/testnim '+shellcode).read()
    return yesxor

def filehex(binfile,type):
    shellcodefilename = filesha256()
    f = open(binfile, "rb")
    n = 0
    s = f.read(1)
    while s:
        byte = ord(s)
        n = n + 1
        print('%02x' % (byte), end='',file=open('./files/'+shellcodefilename,'a'))
        s = f.read(1)
    f.close()
    shellcodefile = open('./files/' + shellcodefilename)#为了删除文件只能这么写
    shellcode = shellcodefile.read()
    shellcodefile.close()
    os.remove(binfile)
    os.remove('./files/'+shellcodefilename)
    shellcode = shellcodexor(shellcode).replace('\n', '').replace('\r', '')
    print (shellcode)
    codeing = open('./code/codeing.nim',encoding="utf8").read()
    if type == 'i386':
        codeing = re.sub(r'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA',shellcode,codeing)
        return codetoexe(codeing,type)
    elif type == 'amd64':
        codeing = re.sub(r'BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB',shellcode,codeing)
        return codetoexe(codeing,type)


@require_POST
def upload(request):
    file = request.FILES.get("filename", None)
    select_form = SelectTestForm(request.POST)
    if select_form.is_valid():
        get_value = request.POST.get('sel_value', "")
    else:
        pass
    if not file:
        return render_home_template(request)

    pathname = os.path.join(SAVED_FILES_DIR, filesha256())

    with open(pathname, 'wb+') as destination:
        for chunk in file.chunks():
            destination.write(chunk)
    exefile = filehex(pathname,get_value)
    return HttpResponseRedirect('/download/'+exefile)