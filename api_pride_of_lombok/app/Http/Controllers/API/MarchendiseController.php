<?php

namespace App\Http\Controllers\API;

use Illuminate\Http\Request;
use App\Models\Marchendise;
use App\Helpers\ApiFormatter;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Validator;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Support\Facades\DB;

class MarchendiseController extends Controller
{

    public function index()
    {
        $data = Marchendise::all();

        if($data) {
            return ApiFormatter::createApi(200, 'success', $data);
        }else {
            return ApiFormatter::createApi(400, 'failed');
        }
    }

    public function getMarchendiseBySearch($value){
        $barang_dicari =  DB::select("select * from marchendise where nama like '%$value%' or jenis like '%$value%'"); 

        return ApiFormatter::createApi(200, 'success', $barang_dicari);


    }

    public function tambahMarchendise(Request $request)
    {
      
        // validasi data

        $validation = Validator::make($request->all(), [ 
            'nama' =>'required|max:128',
            'jenis' =>'required|max:128',
            'deskripsi' =>'required|max:5000',
            'harga' =>'required|integer|digits_between:1,20',
            'gambar' => 'required|mimes:jpg,bmp,png|max:500'
        ]);

        if($validation->fails()){
            return ApiFormatter::createApi(400, 'Failed', $validation->errors()); 
        }

        // Upload gambar 
        $file = $request->file('gambar');
        $file_name = $file->getClientOriginalName();
        $file->move(public_path('/images/marchendise/'), $file_name); 

        // Buat object data marchendise
        $marchendise = new Marchendise();

        $marchendise->nama = $request['nama'];
        $marchendise->jenis = $request['jenis'];
        $marchendise->deskripsi = $request['deskripsi'];
        $marchendise->harga = $request['harga'];
        $marchendise->gambar = $file_name;

        # save data
        $marchendise->save();

        return ApiFormatter::createApi(200, 'Success');  
    }

    public function detailMarchendise($marchendise_id)
    {
        try {
            $marchendise = Marchendise::findorFail($marchendise_id);
            return ApiFormatter::createApi(200, 'Success', $marchendise);
        } catch (ModelNotFoundException $e) {
            return ApiFormatter::createApi(404, 'Failed', "Tidak ditemukan");
        }
    }


    public function editMarchendise(Request $request, $marchendise_id)
    {
        // validasi data
        $validation = Validator::make($request->all(), [ 
            'nama' =>'required|max:128',
            'jenis' =>'required|max:128',
            'deskripsi' =>'required|max:5000',
            'harga' =>'required|integer|digits_between:1,20',
            'gambar' => 'mimes:jpg,bmp,png|max:500'
        ]);

        if($validation->fails()){
            return ApiFormatter::createApi(400, 'Failed', $validation->errors()); 
        }

        // get data saat ini
        $marchendise = Marchendise::findOrFail($marchendise_id);

        // check gambar baru di upload atau tidak
        if(!($request->hasFile('gambar'))){ 
            // gunakan gambar lama
            $file_name = $marchendise->gambar;
        }else {
            // Upload gambar baru
            $file = $request->file('gambar');
            $file_name = $file->getClientOriginalName();
            $file->move(public_path('/images/marchendise/'), $file_name); 
        }

        // Update data
        $marchendise->nama = $request['nama'];
        $marchendise->jenis = $request['jenis'];
        $marchendise->deskripsi = $request['deskripsi'];
        $marchendise->harga = $request['harga'];
        $marchendise->gambar = $file_name;

        //  save data
        $marchendise->save();

        return ApiFormatter::createApi(200, 'Success'); 
 
    }

    public function hapusMarchendise($marchendise_id)
    {        
        try {
            // cari marchendise yang ingin dihapus
            $marchendise = Marchendise::findorFail($marchendise_id);

            // Hapus marchendise
            $marchendise->delete();

            return ApiFormatter::createApi(200, 'Success', "Berhasil dihapus");

        } catch (ModelNotFoundException $e) {

            // Jika id marchendise tidak ada beri info
            return ApiFormatter::createApi(404, 'Failed', "Tidak ditemukan");
        }
    }
}
