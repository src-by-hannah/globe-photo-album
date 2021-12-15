'''
용도 : 파일명 변경 src code

last updated... 21.12.16.
@src-by-hannah
'''

import os

# txt로 file path 및 number of file 저장
f = open("folder_info.txt", 'w', encoding="UTF8")

# photo 안의 모든 폴더에 대해
folder_path = '.\\photo'
folder_list = os.listdir(folder_path)
print('folder list :', folder_list)

for folder in folder_list :
    print("\n\n[[[", folder, "]]]")
    
    file_path = folder_path + "\\" + folder
    file_names = os.listdir(file_path)
    print(file_names)
    
    # 파일 이름 변경
    i = 1
    for name in file_names:
        src = os.path.join(file_path, name)
        
        dst = str(i) + '.jpg'
        dst = os.path.join(file_path, dst)
        
        if (src == dst) :
            print("already changed...")
            break
        else :
            os.rename(src, dst)
        
        i += 1
    
    # file로 저장
    f.write(file_path + '\t' + str(len(file_names)) + '\n')

f.close()