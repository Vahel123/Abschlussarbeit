// Code generated by protoc-gen-gogo. DO NOT EDIT.
// source: fccontrol.proto

package fccontrol

import (
	context "context"
	fmt "fmt"
	github_com_containerd_ttrpc "github.com/containerd/ttrpc"
	proto1 "github.com/firecracker-microvm/firecracker-containerd/proto"
	proto "github.com/gogo/protobuf/proto"
	empty "github.com/golang/protobuf/ptypes/empty"
	math "math"
)

// Reference imports to suppress errors if they are not otherwise used.
var _ = proto.Marshal
var _ = fmt.Errorf
var _ = math.Inf

// This is a compile-time assertion to ensure that this generated file
// is compatible with the proto package it is being compiled against.
// A compilation error at this line likely means your copy of the
// proto package needs to be updated.
const _ = proto.GoGoProtoPackageIsVersion3 // please upgrade the proto package

func init() { proto.RegisterFile("fccontrol.proto", fileDescriptor_b99f53e2bf82c5ef) }

var fileDescriptor_b99f53e2bf82c5ef = []byte{
	// 261 bytes of a gzipped FileDescriptorProto
	0x1f, 0x8b, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0xff, 0xe2, 0xe2, 0x4f, 0x4b, 0x4e, 0xce,
	0xcf, 0x2b, 0x29, 0xca, 0xcf, 0xd1, 0x2b, 0x28, 0xca, 0x2f, 0xc9, 0x97, 0x92, 0x4e, 0xcf, 0xcf,
	0x4f, 0xcf, 0x49, 0xd5, 0x07, 0xf3, 0x92, 0x4a, 0xd3, 0xf4, 0x53, 0x73, 0x0b, 0x4a, 0x2a, 0xa1,
	0x92, 0x82, 0x69, 0x99, 0x45, 0xa9, 0xc9, 0x45, 0x89, 0xc9, 0xd9, 0xa9, 0x45, 0x10, 0x21, 0xa3,
	0x57, 0x4c, 0x5c, 0xdc, 0x6e, 0x08, 0x51, 0x21, 0x7d, 0x2e, 0x0e, 0xe7, 0xa2, 0xd4, 0xc4, 0x92,
	0xd4, 0x30, 0x5f, 0x21, 0x01, 0x3d, 0x18, 0x33, 0x28, 0xb5, 0xb0, 0x34, 0xb5, 0xb8, 0x44, 0x4a,
	0x10, 0x49, 0xa4, 0xb8, 0x20, 0x3f, 0xaf, 0x38, 0x55, 0xc8, 0x80, 0x8b, 0x2d, 0xb8, 0x24, 0xbf,
	0x20, 0xcc, 0x57, 0x88, 0x4f, 0x0f, 0xc2, 0x80, 0x29, 0x16, 0xd3, 0x83, 0xb8, 0x45, 0x0f, 0xe6,
	0x16, 0x3d, 0x57, 0x90, 0x5b, 0x84, 0x8c, 0xb8, 0x38, 0xdd, 0x53, 0x4b, 0xc2, 0x7c, 0x3d, 0xf3,
	0xd2, 0xf2, 0x85, 0x04, 0xf5, 0xe0, 0x6c, 0x98, 0x3e, 0x21, 0x64, 0x21, 0xa8, 0x2d, 0x76, 0x5c,
	0xbc, 0xc1, 0x20, 0x41, 0xdf, 0xd4, 0x92, 0xc4, 0x94, 0xc4, 0x92, 0x44, 0x21, 0x51, 0x3d, 0x14,
	0x3e, 0x21, 0x3b, 0x5d, 0xb8, 0x04, 0x42, 0x0b, 0x52, 0xc0, 0x2e, 0x87, 0x1b, 0x21, 0xa1, 0x87,
	0x2e, 0x44, 0xc8, 0x14, 0x3b, 0x2e, 0x5e, 0x77, 0x34, 0x57, 0xb8, 0x63, 0x77, 0x05, 0x9a, 0x30,
	0xc4, 0x17, 0x4e, 0xca, 0x27, 0x1e, 0xca, 0x31, 0xdc, 0x78, 0x28, 0xc7, 0xd0, 0xf0, 0x48, 0x8e,
	0xf1, 0xc4, 0x23, 0x39, 0xc6, 0x0b, 0x8f, 0xe4, 0x18, 0x1f, 0x3c, 0x92, 0x63, 0x8c, 0xe2, 0x84,
	0xc7, 0x63, 0x12, 0x1b, 0xd8, 0x52, 0x63, 0x40, 0x00, 0x00, 0x00, 0xff, 0xff, 0x0c, 0x15, 0x3e,
	0x05, 0xdb, 0x01, 0x00, 0x00,
}

type FirecrackerService interface {
	CreateVM(ctx context.Context, req *proto1.CreateVMRequest) (*proto1.CreateVMResponse, error)
	StopVM(ctx context.Context, req *proto1.StopVMRequest) (*empty.Empty, error)
	GetVMInfo(ctx context.Context, req *proto1.GetVMInfoRequest) (*proto1.GetVMInfoResponse, error)
	SetVMMetadata(ctx context.Context, req *proto1.SetVMMetadataRequest) (*empty.Empty, error)
	UpdateVMMetadata(ctx context.Context, req *proto1.UpdateVMMetadataRequest) (*empty.Empty, error)
	GetVMMetadata(ctx context.Context, req *proto1.GetVMMetadataRequest) (*proto1.GetVMMetadataResponse, error)
}

func RegisterFirecrackerService(srv *github_com_containerd_ttrpc.Server, svc FirecrackerService) {
	srv.Register("Firecracker", map[string]github_com_containerd_ttrpc.Method{
		"CreateVM": func(ctx context.Context, unmarshal func(interface{}) error) (interface{}, error) {
			var req proto1.CreateVMRequest
			if err := unmarshal(&req); err != nil {
				return nil, err
			}
			return svc.CreateVM(ctx, &req)
		},
		"StopVM": func(ctx context.Context, unmarshal func(interface{}) error) (interface{}, error) {
			var req proto1.StopVMRequest
			if err := unmarshal(&req); err != nil {
				return nil, err
			}
			return svc.StopVM(ctx, &req)
		},
		"GetVMInfo": func(ctx context.Context, unmarshal func(interface{}) error) (interface{}, error) {
			var req proto1.GetVMInfoRequest
			if err := unmarshal(&req); err != nil {
				return nil, err
			}
			return svc.GetVMInfo(ctx, &req)
		},
		"SetVMMetadata": func(ctx context.Context, unmarshal func(interface{}) error) (interface{}, error) {
			var req proto1.SetVMMetadataRequest
			if err := unmarshal(&req); err != nil {
				return nil, err
			}
			return svc.SetVMMetadata(ctx, &req)
		},
		"UpdateVMMetadata": func(ctx context.Context, unmarshal func(interface{}) error) (interface{}, error) {
			var req proto1.UpdateVMMetadataRequest
			if err := unmarshal(&req); err != nil {
				return nil, err
			}
			return svc.UpdateVMMetadata(ctx, &req)
		},
		"GetVMMetadata": func(ctx context.Context, unmarshal func(interface{}) error) (interface{}, error) {
			var req proto1.GetVMMetadataRequest
			if err := unmarshal(&req); err != nil {
				return nil, err
			}
			return svc.GetVMMetadata(ctx, &req)
		},
	})
}

type firecrackerClient struct {
	client *github_com_containerd_ttrpc.Client
}

func NewFirecrackerClient(client *github_com_containerd_ttrpc.Client) FirecrackerService {
	return &firecrackerClient{
		client: client,
	}
}

func (c *firecrackerClient) CreateVM(ctx context.Context, req *proto1.CreateVMRequest) (*proto1.CreateVMResponse, error) {
	var resp proto1.CreateVMResponse
	if err := c.client.Call(ctx, "Firecracker", "CreateVM", req, &resp); err != nil {
		return nil, err
	}
	return &resp, nil
}

func (c *firecrackerClient) StopVM(ctx context.Context, req *proto1.StopVMRequest) (*empty.Empty, error) {
	var resp empty.Empty
	if err := c.client.Call(ctx, "Firecracker", "StopVM", req, &resp); err != nil {
		return nil, err
	}
	return &resp, nil
}

func (c *firecrackerClient) GetVMInfo(ctx context.Context, req *proto1.GetVMInfoRequest) (*proto1.GetVMInfoResponse, error) {
	var resp proto1.GetVMInfoResponse
	if err := c.client.Call(ctx, "Firecracker", "GetVMInfo", req, &resp); err != nil {
		return nil, err
	}
	return &resp, nil
}

func (c *firecrackerClient) SetVMMetadata(ctx context.Context, req *proto1.SetVMMetadataRequest) (*empty.Empty, error) {
	var resp empty.Empty
	if err := c.client.Call(ctx, "Firecracker", "SetVMMetadata", req, &resp); err != nil {
		return nil, err
	}
	return &resp, nil
}

func (c *firecrackerClient) UpdateVMMetadata(ctx context.Context, req *proto1.UpdateVMMetadataRequest) (*empty.Empty, error) {
	var resp empty.Empty
	if err := c.client.Call(ctx, "Firecracker", "UpdateVMMetadata", req, &resp); err != nil {
		return nil, err
	}
	return &resp, nil
}

func (c *firecrackerClient) GetVMMetadata(ctx context.Context, req *proto1.GetVMMetadataRequest) (*proto1.GetVMMetadataResponse, error) {
	var resp proto1.GetVMMetadataResponse
	if err := c.client.Call(ctx, "Firecracker", "GetVMMetadata", req, &resp); err != nil {
		return nil, err
	}
	return &resp, nil
}