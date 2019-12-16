package com.skytech.skyimplugin;

import java.util.List;

/*

 * File: BackJson.java

 * Author: jianglj

 * Create: 2019-12-10 09:50

 */public class BackJson {

     private boolean isSuccess;
     private String code;
     private String message;
     private List<Object> list;
     private Object obj;

    public Object getObj() {
        return obj;
    }

    public void setObj(Object obj) {
        this.obj = obj;
    }

    public List<Object> getList() {
        return list;
    }

    public void setList(List<Object> list) {
        this.list = list;
    }


    public boolean isSuccess() {
        return isSuccess;
    }

    public void setSuccess(boolean success) {
        isSuccess = success;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }


}
