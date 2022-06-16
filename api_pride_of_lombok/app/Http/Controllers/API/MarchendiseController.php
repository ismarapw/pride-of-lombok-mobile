<?php

namespace App\Http\Controllers\API;

use Illuminate\Http\Request;
use App\Models\Marchendise;
use App\Helpers\ApiFormatter;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Validator;

class MarchendiseController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $data = Marchendise::all();

        if($data) {
            return ApiFormatter::createApi(200, 'success', $data);
        }else {
            return ApiFormatter::createApi(400, 'failed');
        }
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
      
        // validasi data
        $validation = Validator::make($request->all(), [ 
            'nama' =>'required|max:128',
            'jenis' =>'required|max:128',
            'deskripsi' =>'required|max:5000',
            'harga' =>'required|integer|digits_between:1,20',
            'gambar' => 'required|mimes:jpg,bmp,png'
        ]);

        if($validation->fails()){
            return ApiFormatter::createApi(400, 'Failed', $validation->errors()); 
        }else {
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

              return ApiFormatter::createApi(200, 'Success', $marchendise); 
        }
 
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        $marchendise = Marchendise::findOrFail($id);
        return ApiFormatter::createApi(200, 'Success', $marchendise);
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit(Request $request, $id)
    {
        // validasi data
        $validation = Validator::make($request->all(), [ 
            'nama' =>'required|max:128',
            'jenis' =>'required|max:128',
            'deskripsi' =>'required|max:5000',
            'harga' =>'required|integer|digits_between:1,20',
            'gambar' => 'required'
        ]);

        if($validation->fails()){
            return ApiFormatter::createApi(400, 'Failed', $validation->errors()); 
        }else {
            // get data saat ini
            $marchendise = Marchendise::findOrFail($id);

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

            return ApiFormatter::createApi(200, 'Success', $marchendise); 
        }
 
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        //
    }
}
