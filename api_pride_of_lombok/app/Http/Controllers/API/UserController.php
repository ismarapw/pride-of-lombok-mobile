<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Helpers\ApiFormatter;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use App\Models\User;

class UserController extends Controller
{
	// Fungsi get user
	public function getUser($id){
		$userData = User::findOrFail($id);
		
		if($userData) {
            return ApiFormatter::createApi(200, 'success', $userData);
        }else {
            return ApiFormatter::createApi(400, 'failed');
        }
	
	}
	
    //Fungsi autentikasi Login
    public function login(Request $request){

        // Cek input value 
        $validation =  Validator::make($request->all(),[
            'username' =>'required',
            'password' =>'required',
        ]); 

        // cek validasi
        if($validation ->fails()){
            return ApiFormatter::createApi(400, 'Failed', $validation->errors()); 
        }

        $credentials = [
            "username" => $request->username,
            "password"=> $request->password
        ];
        
        // Cek kesesuaian username dan password 
        if (Auth::attempt($credentials)) {
			
            return ApiFormatter::createApi(200, 'success', Auth::user());
        }else {
            return ApiFormatter::createApi(400, 'failed', ["not valid" => ["Username atau password Salah"]]);
        }
        
    }

     // Fungsi registrasi user
     public function register(Request $request){

        // Validasi data
        $validation = Validator::make($request->all(),[
            'username' => 'required|max:255|unique:users,username',
            'email' => 'required|unique:users,email|email:dns',
            'password'=> 'required|min:5|max:255'
        ]);

        // cek validasi
        if($validation->fails()){
            return ApiFormatter::createApi(400, 'Failed', $validation->errors()); 
        }

        // buat user baru
        $user = new User();
        $user->username = $request['username'];
        $user->password = bcrypt($request['password']);
        $user->email = $request['email'];
        $user->save();

        return ApiFormatter::createApi(200, 'Success', $user); 
    }

    public function editProfile(Request $request, $id_user){
         // validasi username dan email
         $validation = Validator::make($request->all(),[
            'username' => 'required|max:255|unique:users,username,'.$id_user,
            'email' => 'required|email:dns|unique:users,email,'.$id_user 
        ]);

        // cek validasi username dan email
        if($validation->fails()){
            return ApiFormatter::createApi(400, 'Failed', $validation->errors()); 
        }

        // Cek nilai password
        if(is_null($request->password)){
            // kalau input kosong pakai password lama
            $new_password = User::findorFail($id_user)->password;
        }else {
            // kalau input ada, pakai passoword baru tapi minimal 5 dan maximal 255 
            $validation = Validator::make($request->all(),[
                'password'=> 'min:5|max:255'
            ]);

            // cek validasi password
            if($validation->fails()){
                return ApiFormatter::createApi(400, 'Failed', $validation->errors()); 
            }

            $new_password = bcrypt($request->password);
        }

        // edit data user sesuai input
        $user = User::findOrFail($id_user);
        $user->username = $request->username;
        $user->email = $request->email;
        $user->password = $new_password;
        $user->save();
        
        return ApiFormatter::createApi(200, 'Success', $user);
    }


}
